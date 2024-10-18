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
    rev = "refs/tags/1.1.7-release";
    hash = "sha256-0ylG/2ZSO3b8zdh6W9QJH5OJW9V344CCik1DduV5mhI=";
  };

  nativeBuildInputs = [
    clang
    automake
    autogen
    autoconf
  ];

  configurePhase = ''
    runHook preConfigure
    ./autogen.sh
    ./configure --prefix=$out --without-tls
    runHook postConfigure
  '';

  doCheck = true;
  checkPhase = "make check";

  meta = {
    description = "A portable framework for the Objective-C language";
    homepage = "https://github.com/ObjFW/ObjFW";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
