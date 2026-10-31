{ stdenv }:
crateName: metadata: buildTests:
if !buildTests then
  ''
    runHook preInstall
    # always create $out even if we do not have binaries. We are detecting binary targets during compilation, if those are missing there is no way to only have $lib
    mkdir $out
    if [[ -s target/env ]]; then
      mkdir -p $lib
      cp target/env $lib/env
    fi
    if [[ -s target/link.final ]]; then
      mkdir -p $lib/lib
      cp target/link.final $lib/lib/link
    fi
    if [[ "$(ls -A target/lib)" ]]; then
      mkdir -p $lib/lib
      cp -r target/lib/* $lib/lib #*/
      for library in $lib/lib/*.so $lib/lib/*.dylib; do #*/
        ln -s $library $(echo $library | sed -e "s/-${metadata}//")
      done
    fi
    if [[ "$(ls -A target/build)" ]]; then # */
      mkdir -p $lib/lib
      cp -r target/build/* $lib/lib # */
    fi
    if [[ -d target/bin ]]; then
      if [[ "$(ls -A target/bin)" ]]; then
        mkdir -p $out/bin
        cp -rP target/bin/* $out/bin # */
      fi
    fi
    runHook postInstall
  ''
else
  # for tests we just put them all in the output. No execution.
  ''
    runHook preInstall

    mkdir -p $out/tests
    if [ -e target/bin ]; then
      find target/bin/ -type f -executable -exec cp {} $out/tests \;
    fi
    if [ -e target/lib ]; then
      find target/lib/ -type f \! -name '*.rlib' \
        -a \! -name '*${stdenv.hostPlatform.extensions.library}' \
        -a \! -name '*.d' \
        -executable \
        -print0 | xargs --no-run-if-empty --null install --target $out/tests;
    fi
    # Emit a manifest mapping each binary in $out/tests back to the cargo
    # target it was compiled from (kind, target name, source file). The
    # output filenames don't match cargo's naming for lib tests
    # (metadata-hash suffix) or, historically, multi-file integration
    # tests; recording the mapping at build time saves consumers from
    # reverse-engineering lib.sh. Dotfile so existing $out/tests/* globs
    # don't pick it up.
    [ -f target/test-targets.jsonl ] || : > target/test-targets.jsonl
    jq -s '.' target/test-targets.jsonl > $out/tests/.target-manifest.json
    # Real (non-test) binaries that integration tests may exec via
    # CARGO_BIN_EXE_<name>.
    if [ -d target/cargo-bin-exe ]; then
      mkdir -p $out/bin
      cp -rP target/cargo-bin-exe/* $out/bin
    fi

    runHook postInstall
  ''
