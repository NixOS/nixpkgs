{
  autoconf,
  autogen,
  automake,
  clang,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "ObjFW";
    repo = "ObjFW";
    rev = "f33bd5b5dec1c30ba0a1f0d8ad8fbfa15a6ef3ff";
    hash = "sha256-0ylG/2ZSO3b8zdh6W9QJH5OJW9V344CCik1DduV5mhI=";
  };

  nativeBuildInputs = [
    clang
    automake
    autogen
    autoconf
  ];

  buildPhase = ''
    ./autogen.sh
    ./configure --prefix=$out --without-tls
    make
  '';

  doCheck = true;
  checkPhase = "make check";
  installPhase = "make install";
  meta = with lib; {
    description = "A portable framework for the Objective-C language";
    homepage = "https://github.com/ObjFW/ObjFW";
    license = licenses.lgpl3;
    maintainers = [ maintainers.steeleduncan ];
    platforms = platforms.linux;
  };
})
