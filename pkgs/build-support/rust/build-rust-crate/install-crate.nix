crateName: metadata:
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
    cp target/lib/* $lib/lib #*/
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
      cp -P target/bin/* $out/bin # */
    fi
  fi
  runHook postInstall
''
