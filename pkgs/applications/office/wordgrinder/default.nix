{ lib, stdenv, fetchFromGitHub, pkg-config, makeWrapper
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

  preBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeFlagsArray+=('XFT_PACKAGE=--cflags={} --libs={-lX11 -lXft}')
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontConfigure = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    ninja
  ];

  buildInputs = [
    lua52Packages.lua
    ncurses
    readline
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libXft
  ];

  # To be able to find <Xft.h>
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-I${libXft.dev}/include/X11";

  # Binaries look for LuaFileSystem library (lfs.so) at runtime
  postInstall = ''
    wrapProgram $out/bin/wordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/xwordgrinder --set LUA_CPATH "${lua52Packages.luafilesystem}/lib/lua/5.2/lfs.so";
  '';

  meta = with lib; {
    description = "Text-based word processor";
    homepage = "https://cowlark.com/wordgrinder";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
