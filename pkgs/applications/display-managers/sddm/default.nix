{
  lib,
  callPackage,
  runCommand,
  layer-shell-qt ? null,
  qtwayland,
  wrapQtAppsHook,
  unwrapped ? callPackage ./unwrapped.nix { },
  withWayland ? false,
  withLayerShellQt ? false,
  extraPackages ? [ ],
}:
runCommand "sddm-wrapped"
  {
    inherit (unwrapped) version outputs;

    buildInputs =
      unwrapped.buildInputs
      ++ extraPackages
      ++ lib.optional withWayland qtwayland
      ++ lib.optional (withWayland && withLayerShellQt) layer-shell-qt;
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
