{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper
, lua52Packages, libXft, ncurses, ninja, readline, zlib }:

stdenv.mkDerivation rec {
  pname = "wordgrinder";
  version = "0.8";

  src = fetchFromGitHub {
    repo = "wordgrinder";
    owner = "davidgiven";
    rev = version;
    sha256 = "124d1bnn2aqs6ik8pdazzni6a0583prz9lfdjrbwyb97ipqga9pm";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LUA_INCLUDE=${lua52Packages.lua}/include"
    "LUA_LIB=${lua52Packages.lua}/lib/liblua.so"
    "OBJDIR=$TMP/wg-build"
  ];

  preBuild = stdenv.lib.optionalString stdenv.isLinux ''
    makeFlagsArray+=('XFT_PACKAGE=--cflags={} --libs={-lX11 -lXft}')
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontConfigure = true;

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    ninja
  ];

  buildInputs = [
    lua52Packages.lua
    ncurses
    readline
    zlib
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    libXft
  ];

  # To be able to find <Xft.h>
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isLinux "-I${libXft.dev}/include/X11";

  # Binaries look for LuaFileSystem library (lfs.so) at runtime
  postInstall = ''
    wrapProgram $out/bin/wordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/xwordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '';

  meta = with stdenv.lib; {
    description = "Text-based word processor";
    homepage = "https://cowlark.com/wordgrinder";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
