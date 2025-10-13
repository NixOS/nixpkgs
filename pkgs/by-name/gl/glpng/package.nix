{
  lib,
  stdenv,
  fetchFromRepoOrCz,
  cmake,
  libGL,
  libpng,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "glpng";
  version = "1.47";

  src = fetchFromRepoOrCz {
    repo = "glpng";
    rev = "v${version}";
    hash = "sha256-mwh0E8OZKBf6UcRScAeco8dfQ4LJ+7TG0IPuRi3Mzfc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    libpng
    zlib
  ];

  meta = with lib; {
    homepage = "https://repo.or.cz/glpng.git/blob_plain/HEAD:/glpng.htm";
    description = "PNG loader library for OpenGL";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
