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
    # the lua derivation to convert into a neovim plugin
     luaAttr ? (lua.pkgs.${normalizeName attrs.pname})
    , ...
  }@attrs:
    let
      originalLuaDrv = if (lib.typeOf luaAttr == "string") then
        lib.warn "luaAttr as string is deprecated since September 2024. Pass a lua derivation directly ( e.g., `buildNeovimPlugin { luaAttr = lua.pkgs.plenary-nvim; }`)" lua.pkgs.${normalizeName luaAttr}
        else luaAttr;


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
