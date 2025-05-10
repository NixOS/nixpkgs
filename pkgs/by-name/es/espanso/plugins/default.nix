{
  lib,
  callPackage,
  stdenvNoCC,
  writeShellScript,
}:
let
  mkEspansoPlugin =
    attrs@{
      pname,
      version,
      meta ? { },
      ...
    }:
    stdenvNoCC.mkDerivation (
      attrs
      // {
        installPhase = ''
          runHook preInstall

          cp -r packages/${pname}/${version} $out

          runHook postInstall
        '';
        meta = meta // {
          description = meta.description or "";
          platforms = meta.platforms or lib.platforms.all;
        };
        passthru = (attrs.passthru or { }) // {
          updateScript = {
            command = writeShellScript "update-${pname}" ''
              exec ${./update.py} ${pname}
            '';
            supportedFeatures = [ "commit" ];
          };
        };
      }
    );
  call = name: callPackage (./. + "/${name}") { inherit mkEspansoPlugin; };
in
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
// {
  inherit mkEspansoPlugin;
}
