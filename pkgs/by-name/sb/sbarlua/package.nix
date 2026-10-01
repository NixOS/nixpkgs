{
  lib,
  fetchFromGitHub,
  gcc,
  lua55Packages,
  readline,
}:
lua55Packages.buildLuaPackage {
  pname = "sbarLua";
  version = "0-unstable-2026-03-06";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "dba9cc421b868c918d5c23c408544a28aadf2f2f";
    hash = "sha256-lhLTrdufA3ALJ2S5HLdgNOr5seWIWEHkVhZNPObzbvI=";
  };

  nativeBuildInputs = [ gcc ];

  buildInputs = [ readline ];

  makeFlags = [ "INSTALL_DIR=$(out)/lib/lua/${lua55Packages.lua.luaversion}" ];

  meta = {
    description = "Lua API for SketchyBar";
    homepage = "https://github.com/FelixKratz/SbarLua/";
    license = lib.licenses.gpl3;
    maintainers = [
      lib.maintainers.khaneliman
      lib.maintainers.kaynetik
    ];
    platforms = lib.platforms.darwin;
  };
}
