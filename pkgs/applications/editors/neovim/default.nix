{ stdenv, fetchFromGitHub, unzip, ncurses, gettext, pkgconfig
, cmake, pkgs, lpeg, lua, luajit, luaMessagePack, luabitop }:

let version = "2014-11-26"; in
stdenv.mkDerivation rec {
  name = "neovim-${version}";

  src = fetchFromGitHub {
    sha256 = "1bcmv0h3ln736xdv7r7v97vim2yqfdnkvpbckwdxi69p4d6lfms6";
    rev = "68fcd8b696dae33897303c9f8265629a31afbf17";
    repo = "neovim";
    owner = "neovim";
  };

  libmsgpack = stdenv.mkDerivation rec {
    version = "0.5.9";
    name = "libmsgpack-${version}";

    src = fetchFromGitHub {
      sha256 = "12np3c2q346963mdgwa61y5dfnb91avq2hy4r6i6bdjwa7w6waq4";
      rev = "ecf4b09acd29746829b6a02939db91dfdec635b4";
      repo = "msgpack-c";
      owner = "msgpack";
    };

    buildInputs = [ cmake ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "MessagePack implementation for C and C++";
      homepage = http://msgpack.org;
      license = licenses.asl20;
      maintainers = with maintainers; [ manveru nckx ];
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
    description = "Vim text editor fork focused on extensibility and agility";
    longDescription = ''
      Neovim is a project that seeks to aggressively refactor Vim in order to:
      - Simplify maintenance and encourage contributions
      - Split the work between multiple developers
      - Enable the implementation of new/modern user interfaces without any
        modifications to the core source
      - Improve extensibility with a new plugin architecture
    '';
    homepage    = http://www.neovim.org;
    # "Contributions committed before b17d96 by authors who did not sign the
    # Contributor License Agreement (CLA) remain under the Vim license.
    # Contributions committed after b17d96 are licensed under Apache 2.0 unless
    # those contributions were copied from Vim (identified in the commit logs
    # by the vim-patch token). See LICENSE for details."
    license = with licenses; [ asl20 vim ];
    maintainers = with maintainers; [ manveru nckx ];
    platforms   = platforms.unix;
  };
}
