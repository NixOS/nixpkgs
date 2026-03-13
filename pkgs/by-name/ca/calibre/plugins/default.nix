{
  lib,
  callPackage,
  fetchurl,
  stdenvNoCC,
}:
let
  root = ./.;

  mkCalibrePlugin =
    args@{
      pname,
      version,
      url ? null,
      src ? null,
      sha256 ? null,
      hash ? null,
      meta ? { },
      installPhase ? null,
      ...
    }:
    let
      # If src is not provided, create it from url and hash/sha256
      pluginSrc =
        if src != null then
          src
        else
          fetchurl ({ inherit url; } // (if hash != null then { inherit hash; } else { inherit sha256; }));
    in
    stdenvNoCC.mkDerivation (
      args
      // {
        inherit pname version;
        src = pluginSrc;

        dontUnpack = true;

        installPhase =
          if installPhase != null then
            installPhase
          else
            ''
              runHook preInstall

              mkdir $out
              cp $src $out/${pname}.zip

              runHook postInstall
            '';

        meta = meta // {
          description = meta.description or "Calibre plugin";
          platforms = meta.platforms or lib.platforms.all;
          homepage = meta.homepage or null;
        };
      }
    );

  call = name: callPackage (root + "/${name}") { inherit mkCalibrePlugin; };
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
// {
  inherit mkCalibrePlugin;
}
