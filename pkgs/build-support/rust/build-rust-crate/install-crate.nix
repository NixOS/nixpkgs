crateName: metadata:
''
  runHook preInstall
  mkdir -p $out
  if [[ -s target/env ]]; then
    cp target/env $out/env
  fi
  if [[ -s target/link.final ]]; then
    mkdir -p $out/lib
    cp target/link.final $out/lib/link
  fi
  if [[ "$(ls -A target/lib)" ]]; then
    mkdir -p $out/lib
    cp target/lib/* $out/lib #*/
    for lib in $out/lib/*.so $out/lib/*.dylib; do #*/
      ln -s $lib $(echo $lib | sed -e "s/-${metadata}//")
    done
  fi
  if [[ "$(ls -A target/build)" ]]; then # */
    mkdir -p $out/lib
    cp -r target/build/* $out/lib # */
  fi
  if [[ -d target/bin ]]; then
    if [[ "$(ls -A target/bin)" ]]; then
      mkdir -p $out/bin
      cp -P target/bin/* $out/bin # */
    fi
  fi
  runHook postInstall
''
