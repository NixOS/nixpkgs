{ lib, stdenv, buildRustCrateHelpers }:
{ crateName
, metadata
, buildKinds
, buildTests
}:
let
  inherit (buildRustCrateHelpers.kinds) kind kindToDir isTest isLib;

  installLib = ''
    # always create $out even if we do not have binaries
    mkdir -p $out
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
  '';

  installKind = k:
    let
      dir = kindToDir k;
    in
    ''
      mkdir -p $out/${dir}
      if [ -e target/${dir} ]; then
        find target/${dir}/ -type f -executable -exec cp {} $out/${dir} \;
      fi
    '';
in
''
  runHook preInstall
  ${lib.concatStringsSep "\n" (builtins.map
    (k: if isLib k then installLib else installKind k)
    buildKinds)
  }
  ${lib.optionalString (buildTests && !(builtins.any isTest buildKinds)) (installKind kind.test)}
  runHook postInstall
''
