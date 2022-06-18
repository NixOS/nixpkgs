{ lib
, stdenv
, buildVimPluginFrom2Nix
, buildLuarocksPackage
, lua51Packages
, toVimPlugin
}:
let
  # sanitizeDerivationName
  normalizeName = name:
    (lib.concatMapStrings (s: if lib.isList s then "-" else s))
      ((builtins.split "[.]") name);
in

rec {
  # function to create vim plugin from lua packages that are already packaged in
  # luaPackages
  buildNeovimPluginFrom2Nix = attrs@{
    # the lua attribute name that matches this vim plugin. Both should be equal
    # in the majority of cases but we make it possible to have different attribute names
    luaAttr ? (normalizeName attrs.pname)
    , ...
  }:
    let
      hasMatch = builtins.hasAttr luaAttr lua51Packages;
      drv = lua51Packages.${luaAttr};
      luaDrv = lua51Packages.lib.overrideLuarocks drv (drv: {
        extraConfig = ''
          -- to create a flat hierarchy
          lua_modules_path = "lua"
        '';
      });
      finalDrv = toVimPlugin (luaDrv.overrideAttrs(oa: {
          nativeBuildInputs = oa.nativeBuildInputs or [] ++ [
            lua51Packages.luarocksMoveDataFolder
          ];
        }));

    in
      finalDrv;
}
