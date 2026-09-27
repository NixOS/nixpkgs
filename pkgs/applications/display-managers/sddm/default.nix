{
  lib,
  callPackage,
  runCommand,
  wrapQtAppsHook,
  sddm-unwrapped,
  extraPackages ? [ ],
}:
runCommand "sddm-wrapped"
  {
    pname = "sddm";
    inherit (sddm-unwrapped) version outputs;

    buildInputs = sddm-unwrapped.buildInputs ++ extraPackages;
    nativeBuildInputs = [ wrapQtAppsHook ];

    strictDeps = true;

    passthru = {
      unwrapped = sddm-unwrapped;
      inherit (sddm-unwrapped.passthru) tests;
    };

    meta = sddm-unwrapped.meta;
  }
  ''
    mkdir -p $out/bin

    cd ${sddm-unwrapped}

    for i in *; do
      if [ "$i" == "bin" ]; then
        continue
      fi
      ln -s ${sddm-unwrapped}/$i $out/$i
    done

    for i in bin/*; do
      makeQtWrapper ${sddm-unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
    done

    mkdir -p $man
    ln -s ${lib.getMan sddm-unwrapped}/* $man/
  ''
