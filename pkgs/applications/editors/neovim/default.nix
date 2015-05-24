{ stdenv, fetchgit, fetchurl, unzip, callPackage, ncurses, gettext, pkgconfig,
cmake, pkgs, lpeg, lua, luajit, luaMessagePack, luabitop, libtermkey,
libvterm, unibilium }:

stdenv.mkDerivation rec {
  name = "neovim-nightly";

  version = "nightly";

  src = fetchgit {
    url = "https://github.com/neovim/neovim";
    rev = "8ef5a61dd6bcaa24d26e450041bcba821fa3dbc7";
    sha256 = "3bc707febe8bedc430b79a9c3d3717abc93d85ded33bcc32268e4f49f75635ff";
  };

  libmsgpack = stdenv.mkDerivation rec {
    version = "1.1.0";
    name = "libmsgpack-${version}";

    src = fetchurl {
      url = "https://github.com/msgpack/msgpack-c/archive/cpp-${version}.tar.gz";
      sha256 = "0a73dmhk0jhwcip1wkvz50cyxsi3alzm6ak187xdai0zdxcck6cd";
    };

    buildInputs = [ cmake ];

    meta = with stdenv.lib; {
      description = "MessagePack implementation for C and C++";
      homepage = http://msgpack.org;
      maintainers = [ maintainers.manveru ];
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };

  enableParallelBuilding = true;

  buildInputs = [
    ncurses
    pkgconfig
    cmake
    pkgs.libuvVersions.v0_11_29
    luajit
    lua
    lpeg
    luaMessagePack
    luabitop
    libmsgpack
    libtermkey
    libvterm
    unibilium
  ];
  nativeBuildInputs = [ gettext ];

  LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;${luabitop}/lib/lua/5.2/?.so";
  LUA_PATH="${luaMessagePack}/share/lua/5.1/?.lua";
  cmakeFlags = [
    "-DUSE_BUNDLED_MSGPACK=ON"
  ];

  meta = with stdenv.lib; {
    description = "Aggressive refactor of Vim";
    homepage    = http://www.neovim.org;
    maintainers = with maintainers; [ manveru ];
    platforms   = platforms.unix;
  };
}

