{
  lua54Packages,
  gcc,
  fetchFromGitHub,
  readline,
  lib,
  ...
}:
let
  name = "sbarlua";
in
lua54Packages.buildLuaPackage {
  inherit name;
  pname = name;
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
    sha256 = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };

  buildInputs = [
    gcc
    readline
  ];

  makeFlags = [ "INSTALL_DIR=$(out)/lib/lua/${lua54Packages.lua.luaversion}" ];

  meta = with lib; {
    description = "Lua bindings for configuring Sketchybar macOS menu bar";
    homepage = "https://github.com/FelixKratz/SbarLua";
    license = licenses.gpl3;
    maintainers = with maintainers; [ amusingimpala75 ];
    platforms = platforms.darwin;
  };
}
