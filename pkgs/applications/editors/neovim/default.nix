{ stdenv, fetchgit, fetchurl, unzip, callPackage, ncurses, gettext, pkgconfig,
cmake, pkgs, lpeg, lua, luajit, luaMessagePack, luabitop }:

stdenv.mkDerivation rec {
  name = "neovim-nightly";

  version = "nightly";

  src = fetchgit {
    url = "https://github.com/neovim/neovim";
    rev = "68fcd8b696dae33897303c9f8265629a31afbf17";
    sha256 = "0hxkcy641jpn4qka44gfvhmb6q3dkjx6lvn9748lcl2gx2d36w4i";
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

