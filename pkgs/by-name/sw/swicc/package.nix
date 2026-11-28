{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  cmake,
}:

stdenv.mkDerivation {
  pname = "swicc";
  version = "0-unstable-2026-05-02";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tomasz-lisowski";
    repo = "swicc";
    rev = "2b9c3257816fdd97f7673f3f6eebed0541202047";
    hash = "sha256-7+kxrZY165aJsVSAZgmcNlazDA8JmK4qdU6DD+ptAUc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    cmake
  ];

  configurePhase = ''
    make main-dbg
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v ./build/libswicc.a $out/lib
    cp -rv ./include $out
  '';

  meta = {
    description = "Framework for creating smart cards";
    homepage = "https://github.com/tomasz-lisowski/swicc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
