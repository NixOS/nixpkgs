{
  runCommand,
  buildEnv,
  makeWrapper,
  lib,
}:
rec {
  makeCustomizable =
    freecad:
    freecad
    // {
      customize =
        {
          name ? freecad.name,
          modules ? [ ],
          pythons ? [ ],
        }:
        let
          wrapPathsStr =
            flag: values:
            builtins.concatStringsSep " " (
              builtins.concatMap (p: [
                "--add-flags"
                flag
                "--add-flags"
                p
              ]) values
            );
          modulesStr = wrapPathsStr "--module-path" modules;
          pythonsStr = wrapPathsStr "--python-path" pythons;
          bin = runCommand "${name}-bin" { nativeBuildInputs = [ makeWrapper ]; } ''
            mkdir -p "$out/bin"
            for exe in FreeCAD{,Cmd}; do
              if [[ ! -e ${freecad}/bin/$exe ]]; then
                echo "No binary $exe in freecad package"
                false
              fi
              dest="$out/bin/$exe";
              makeWrapper "${freecad}/bin/$exe" "$dest" \
                ${modulesStr}                           \
                ${pythonsStr}
            done
            ln -s FreeCAD $out/bin/freecad
            ln -s FreeCADCmd $out/bin/freecadcmd
          '';
        in
        makeCustomizable (buildEnv {
          inherit name;
          paths = [
            (lib.lowPrio freecad)
            bin
          ];
        });
      override = f: makeCustomizable (freecad.override f);
      overrideAttrs = f: makeCustomizable (freecad.overrideAttrs f);
    };
}
