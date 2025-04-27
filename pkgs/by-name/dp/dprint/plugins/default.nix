{
  lib,
  fetchurl,
  stdenv,
}:
let
  mkDprintPlugin =
    {
      url,
      hash,
      pname,
      version,
      description,
      initConfig,
      updateUrl,
      license ? lib.licenses.mit,
      maintainers ? [ lib.maintainers.phanirithvij ],
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version;
      src = fetchurl { inherit url hash; };
      dontUnpack = true;
      meta = {
        inherit description license maintainers;
      };
      /*
        in the dprint configuration
        dprint expects a plugin path to end with .wasm extension

        for auto update with nixpkgs-update to work
        we cannot have .wasm extension at the end in the nix store path
      */
      buildPhase = ''
        mkdir -p $out
        cp $src $out/plugin.wasm
      '';
      passthru = {
        updateScript = ./update-plugins.py;
        inherit initConfig updateUrl;
      };
    });
  inherit (lib)
    filterAttrs
    isDerivation
    mapAttrs'
    nameValuePair
    removeSuffix
    ;
  files = filterAttrs (
    name: type: type == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name
  ) (builtins.readDir ./.);
  plugins = mapAttrs' (
    name: _:
    nameValuePair (removeSuffix ".nix" name) (import (./. + "/${name}") { inherit mkDprintPlugin; })
  ) files;
  # Expects a function that receives the dprint plugin set as an input
  # and returns a list of plugins
  # Example:
  # pkgs.dprint-plugins.getPluginList (plugins: [
  #   plugins.dprint-plugin-toml
  #   (pkgs.callPackage ./dprint/plugins/sample.nix {})
  # ]
  getPluginList = cb: map (p: "${p}/plugin.wasm") (cb plugins);
in
plugins // { inherit mkDprintPlugin getPluginList; }
