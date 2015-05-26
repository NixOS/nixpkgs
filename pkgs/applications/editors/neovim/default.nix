{ stdenv, fetchFromGitHub, cmake, gettext, glib, libmsgpack
, libtermkey, libtool, libuv, lpeg, lua, luajit, luaMessagePack
, luabitop, ncurses, perl, pkgconfig, unibilium
, withJemalloc ? true, jemalloc }:

let version = "2015-05-26"; in
stdenv.mkDerivation rec {
  name = "neovim-${version}";

  src = fetchFromGitHub {
    sha256 = "0sszpqlq0yp6r62zgcjcmnllc058wzzh9ccvgb2jh9k19ksszyhc";
    rev = "5a9ad68b258f33ebd7fa0a5da47b308f50f1e5e7";
    repo = "neovim";
    owner = "neovim";
  };

  # FIXME: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = let version = "2015-02-23"; in stdenv.mkDerivation rec {
    name = "neovim-libvterm-${version}";

    src = fetchFromGitHub {
      sha256 = "0i2h74jrx4fy90sv57xj8g4lbjjg4nhrq2rv6rz576fmqfpllcc5";
      rev = "20ad1396c178c72873aeeb2870bd726f847acb70";
      repo = "libvterm";
      owner = "neovim";
    };

    buildInputs = [ libtool perl ];

    makeFlags = "PREFIX=$(out)";

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "VT220/xterm/ECMA-48 terminal emulator library";
      homepage = http://www.leonerd.org.uk/code/libvterm/;
      license = licenses.mit;
      maintainers = with maintainers; [ nckx ];
      platforms = platforms.unix;
    };
  };

  enableParallelBuilding = true;

  buildInputs = [
    cmake
    glib
    libtermkey
    libuv
    luajit
    lua
    lpeg
    luaMessagePack
    luabitop
    libmsgpack
    ncurses
    neovimLibvterm
    pkgconfig
    unibilium
  ] ++ stdenv.lib.optional withJemalloc jemalloc;
  nativeBuildInputs = [
    gettext
  ];

  LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;${luabitop}/lib/lua/5.2/?.so";
  LUA_PATH="${luaMessagePack}/share/lua/5.1/?.lua";

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
    homepage    = http://www.neovim.io;
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
