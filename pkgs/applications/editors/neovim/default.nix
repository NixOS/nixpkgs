{ stdenv, fetchgit, fetchurl, unzip, callPackage, ncurses, gettext, pkgconfig,
cmake, pkgs, lpeg, lua, luajit, luaMessagePack, luabitop, libtermkey,
libvterm, unibilium }:

stdenv.mkDerivation rec {
  name = "neovim-nightly";

  version = "nightly";

  src = fetchgit {
    url = "https://github.com/neovim/neovim";
    rev = "8c27b0dd45731b1eb70edeafd9729b4d25b07f87";
    sha256 = "5df4ed304451cab35619c5b8c55fe165997f2a3f4aacb68706f77222daa8cd18";
  };

  libmsgpack = stdenv.mkDerivation rec {
    version = "0.5.9";
    name = "libmsgpack-${version}";

    src = fetchgit {
      rev = "ecf4b09acd29746829b6a02939db91dfdec635b4";
      url = "https://github.com/msgpack/msgpack-c";
      sha256 = "076ygqgxrc3vk2l20l8x2cgcv05py3am6mjjkknr418pf8yav2ww";
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

