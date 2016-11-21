{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper
, lua52Packages, libXft, ncurses, readline, zlib }:

stdenv.mkDerivation rec {
  name = "wordgrinder-${version}";
  version = "0.6-db14181";

  src = fetchFromGitHub {
    repo = "wordgrinder";
    owner = "davidgiven";
    rev = "db141815e8bd1da6e684a1142a59492e516f3041";
    sha256 = "1l1jqzcqiwnc8r1igfi7ay4pzzhdhss81znnmfr4rc1ia8bpdjc2";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LUA_INCLUDE=${lua52Packages.lua}/include"
    "LUA_LIB=${lua52Packages.lua}/lib/liblua.so"
  ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [
    libXft
    lua52Packages.lua
    ncurses
    readline
    zlib
  ];

  # To be able to find <Xft.h>
  NIX_CFLAGS_COMPILE = "-I${libXft.dev}/include/X11";

  # Binaries look for LuaFileSystem library (lfs.so) at runtime
  postInstall = ''
    wrapProgram $out/bin/wordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
    wrapProgram $out/bin/xwordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '';

  meta = with stdenv.lib; {
    description = "Text-based word processor";
    homepage = https://cowlark.com/wordgrinder;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
