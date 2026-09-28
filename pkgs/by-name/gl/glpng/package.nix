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

stdenv.mkDerivation (finalAttrs: {
  pname = "glpng";
  version = "1.47";

  src = fetchFromRepoOrCz {
    repo = "glpng";
    rev = "v${finalAttrs.version}";
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

  meta = {
    homepage = "https://repo.or.cz/glpng.git/blob_plain/HEAD:/glpng.htm";
    description = "PNG loader library for OpenGL";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
