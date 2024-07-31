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

      extraConfig = ''
        -- to create a flat hierarchy
        lua_modules_path = "lua"
      '';

      luaDrv = originalLuaDrv.overrideAttrs (oa: {
        version = attrs.version or oa.version;
        rockspecVersion = oa.rockspecVersion;

        # the flat hierarchy needs to be applied to build backends,
        # otherwise luarocks won't find them.
        nativeBuildInputs = map (drv: drv.overrideAttrs (_: {
          inherit extraConfig;
        })) (oa.nativeBuildInputs or []);

        # TODO: This should probably be applied recursively to luarocks packages
        propagatedBuildInputs = map (drv: drv.overrideAttrs (oa': {
          inherit extraConfig;
          nativeBuildInputs = oa'.nativeBuildInputs or [] ++ [
            lua.pkgs.luarocksMoveDataFolder
          ];
        })) (oa.propagatedBuildInputs or []);

        inherit extraConfig;

      });

      finalDrv = toVimPlugin (luaDrv.overrideAttrs(oa: attrs // {
          nativeBuildInputs = oa.nativeBuildInputs or [] ++ [
            lua.pkgs.luarocksMoveDataFolder
          ];
          version = "${originalLuaDrv.version}-unstable-${oa.version}";
        }));
    in
      finalDrv
