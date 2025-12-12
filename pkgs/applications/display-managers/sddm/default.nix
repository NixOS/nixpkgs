{
  lib,
  callPackage,
  runCommand,
  wrapQtAppsHook,
  unwrapped ? callPackage ./unwrapped.nix { },
  extraPackages ? [ ],
}:
runCommand "sddm-wrapped"
  {
    inherit (unwrapped) version outputs;

    buildInputs = unwrapped.buildInputs ++ extraPackages;
    nativeBuildInputs = [ wrapQtAppsHook ];

    strictDeps = true;

    passthru = {
      inherit unwrapped;
      inherit (unwrapped.passthru) tests;
    };

    meta = unwrapped.meta;
  }
  ''
    mkdir -p $out/bin

    cd ${unwrapped}

    for i in *; do
      if [ "$i" == "bin" ]; then
        continue
      fi
      ln -s ${unwrapped}/$i $out/$i
    done

    for i in bin/*; do
      makeQtWrapper ${unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
    done

    mkdir -p $man
    ln -s ${lib.getMan unwrapped}/* $man/
  ''
