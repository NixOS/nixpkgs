{
  lib,
  lua,
  toVimPlugin,
}:
let
  # sanitizeDerivationName
  normalizeName = lib.replaceStrings [ "." ] [ "-" ];
in

# function to create vim plugin from lua packages that are already packaged in
# luaPackages
{
  # the lua derivation to convert into a neovim plugin
  luaAttr ? (lua.pkgs.${normalizeName attrs.pname}),
  ...
}@attrs:
let
  originalLuaDrv =
    if (lib.typeOf luaAttr == "string") then
      lib.warn
        "luaAttr as string is deprecated since September 2024. Pass a lua derivation directly ( e.g., `buildNeovimPlugin { luaAttr = lua.pkgs.plenary-nvim; }`)"
        lua.pkgs.${normalizeName luaAttr}
    else
      luaAttr;

<<<<<<< HEAD
  luaDrv = originalLuaDrv.overrideAttrs (old: {
    version = attrs.version or old.version;
    __intentionallyOverridingVersion = true;
    rockspecVersion = old.rockspecVersion;
=======
  luaDrv = originalLuaDrv.overrideAttrs (oa: {
    version = attrs.version or oa.version;
    __intentionallyOverridingVersion = true;
    rockspecVersion = oa.rockspecVersion;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    extraConfig = ''
      -- to create a flat hierarchy
      lua_modules_path = "lua"
    '';
  });

  finalDrv = toVimPlugin (
    luaDrv.overrideAttrs (
<<<<<<< HEAD
      old:
      attrs
      // {
        nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
          lua.pkgs.luarocksMoveDataFolder
        ];
        version = "${originalLuaDrv.version}-unstable-${old.version}";
=======
      oa:
      attrs
      // {
        nativeBuildInputs = oa.nativeBuildInputs or [ ] ++ [
          lua.pkgs.luarocksMoveDataFolder
        ];
        version = "${originalLuaDrv.version}-unstable-${oa.version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        __intentionallyOverridingVersion = true;
      }
    )
  );
in
finalDrv
