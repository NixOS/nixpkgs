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
            flag:
            builtins.concatMap (p: [
              "--add-flags"
              flag
              p
            ]);
          modulesStr = wrapPathsStr "--module-path" modules;
          pythonsStr = wrapPathsStr "--python-path" pythons;
          bin = runCommand "${name}-bin" { nativeBuildInputs = [ makeWrapper ]; } ''
            mkdir -p "$out/bin"
            for exe in "FreeCad{,Cmd}"; do
              if [[ -e ${freecad}/bin/$exe ]]; then
                dest="$out/bin/$exe";
                makeWrapper "${freecad}/bin/$exe" "$dest" \
                  ${modulesStr}                           \
                  ${pythonsStr}
              fi
            done
            ln -s FreeCad $out/bin/freecad
            ln -s FreeCadCmd $out/bin/freecad-cmd
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
