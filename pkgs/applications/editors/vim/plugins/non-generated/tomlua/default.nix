{ vimUtils, neovim-unwrapped, ... }:
vimUtils.toVimPlugin (
  neovim-unwrapped.lua.pkgs.tomlua.overrideAttrs (old: {
    env = (old.env or { }) // rec {
      LUADIR = placeholder "out" + "/lua";
      LIBDIR = LUADIR;
    };
  })
)
