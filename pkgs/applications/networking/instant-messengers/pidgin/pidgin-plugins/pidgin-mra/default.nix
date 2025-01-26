{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pidgin,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-mra";
  version = "unstable-2014-07-08";

  src = fetchFromGitHub {
    owner = "dreadatour";
    repo = "pidgin-mra";
    rev = "54b299266265cde800289b2d51f13b81f6bf379c";
    sha256 = "sha256-fKdEOaijW2LfsH8RHlVGbMpL7Zhu+x2vW4fPEN4puKk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pidgin ];

  postPatch = ''
    sed -i 's|-I/usr/include/libpurple|$(shell pkg-config --cflags purple)|' Makefile
  '';

  makeFlags = [
    "DESTDIR=/"
    "LIBDIR=${placeholder "out"}/lib"
    "DATADIR=${placeholder "out"}/share"
  ];

  meta = {
    homepage = "https://github.com/dreadatour/pidgin-mra";
    description = "Mail.ru Agent plugin for Pidgin / libpurple";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
