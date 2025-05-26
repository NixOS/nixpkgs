{
  lib,
  fetchFromGitHub,
  gcc,
  lua54Packages,
  readline,
}:
lua54Packages.buildLuaPackage {
  pname = "sbarLua";
  version = "0-unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
    hash = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };

  nativeBuildInputs = [ gcc ];

  buildInputs = [ readline ];

  makeFlags = [ "INSTALL_DIR=$(out)/lib/lua/${lua54Packages.lua.luaversion}" ];

  meta = {
    description = "Lua API for SketchyBar";
    homepage = "https://github.com/FelixKratz/SbarLua/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.khaneliman ];
    platforms = lib.platforms.darwin;
  };
}
