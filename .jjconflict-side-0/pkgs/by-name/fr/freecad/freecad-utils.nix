{
  runCommand,
  buildEnv,
  makeWrapper,
  lib,
  python,
  writeShellScript,
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

  wrapCfgStr =
    typ: val:
    let
      installer = writeShellScript "insteller-${typ}" ''
        dst="$HOME/.config/FreeCAD/${typ}.cfg"
        if [ ! -f "$dst" ]; then
          mkdir -p "$(dirname "$dst")"
          cp --no-preserve=mode,ownership '${val}' "$dst"
        fi
      '';
    in
    lib.optionalString (val != null) "--run ${installer}";

  pythonsProcessed = map (
    pyt:
    if builtins.isString pyt then
      pyt
    else if builtins.isFunction pyt then
      "${(python.withPackages pyt)}/${python.sitePackages}"
    else
      throw "Expected string or function as python paths for freecad"
  );

  makeCustomizable =
    freecad:
    freecad
    // {
      customize =
        {
          name ? freecad.name,
          modules ? [ ],
          pythons ? [ ],
          makeWrapperFlags ? [ ],
          userCfg ? null,
          systemCfg ? null,
        }:
        let
          modulesStr = wrapPathsStr "--module-path" modules;
          pythonsStr = wrapPathsStr "--python-path" (pythonsProcessed pythons);
          makeWrapperFlagsStr = builtins.concatStringsSep " " (map (f: "'${f}'") makeWrapperFlags);

          userCfgStr = wrapCfgStr "user" userCfg;
          systemCfgStr = wrapCfgStr "system" systemCfg;

          bin = runCommand "${name}-bin" { nativeBuildInputs = [ makeWrapper ]; } ''
            mkdir -p "$out/bin"
            for exe in FreeCAD{,Cmd}; do
              if [[ ! -e ${freecad}/bin/$exe ]]; then
                echo "No binary $exe in freecad package"
                false
              fi
              dest="$out/bin/$exe";
              makeWrapper "${freecad}/bin/$exe" "$dest" \
                --inherit-argv0                         \
                ${modulesStr}                           \
                ${pythonsStr}                           \
                ${userCfgStr}                           \
                ${systemCfgStr}                         \
                ${makeWrapperFlagsStr}
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
in
{
  inherit makeCustomizable;
}
