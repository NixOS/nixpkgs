{ lib, fetchurl }:
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
    fetchurl {
      inherit hash url;
      name = "${pname}-${version}.wasm";
      meta = {
        inherit
          description
          license
          maintainers
          ;
      };
      passthru = {
        updateScript = ./update-plugins.py;
        inherit initConfig updateUrl;
      };
    };
  inherit (lib)
    filterAttrs
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
in
plugins // { inherit mkDprintPlugin; }
