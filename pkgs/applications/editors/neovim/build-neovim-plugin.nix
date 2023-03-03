{ lib
, stdenv
, lua
, toVimPlugin
}:
let
  # sanitizeDerivationName
  normalizeName = lib.replaceStrings [ "." ] [ "-" ];
in

  # function to create vim plugin from lua packages that are already packaged in
  # luaPackages
  {
    # the lua attribute name that matches this vim plugin. Both should be equal
    # in the majority of cases but we make it possible to have different attribute names
    luaAttr ? (normalizeName attrs.pname)
    , ...
  }@attrs:
    let
      originalLuaDrv = lua.pkgs.${luaAttr};

      luaDrv = (lua.pkgs.luaLib.overrideLuarocks originalLuaDrv (drv: {
        extraConfig = ''
          -- to create a flat hierarchy
          lua_modules_path = "lua"
        '';
        })).overrideAttrs (drv: {
        version = attrs.version;
        rockspecVersion = drv.rockspecVersion;
      });

      finalDrv = toVimPlugin (luaDrv.overrideAttrs(oa: attrs // {
          nativeBuildInputs = oa.nativeBuildInputs or [] ++ [
            lua.pkgs.luarocksMoveDataFolder
          ];
        }));
    in
      finalDrv
