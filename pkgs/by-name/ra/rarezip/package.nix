{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rarezip";
  version = "0-unstable-2023-09-05";

  src = fetchFromGitHub {
    owner = "MittenzHugg";
    repo = "rarezip";
    rev = "2c4ba146c1b2fec851d3db8cf455c6af090bc544";
    hash = "sha256-t4/DgDeUOZAiX3yc2FUrm5mCRIgX0THFVBFSEYOSAhI=";
  };

  buildPhase = ''
    substituteInPlace gzip/zip.c \
      --replace-fail "size_t bufs_init();" ""

    mkdir c
    make c
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp c/librarezip.a $out/lib
  '';

  meta = {
    description = "Library version gzip v1.2.4 with foreign function interfaces to multiple languages";
    homepage = "https://github.com/MittenzHugg/rarezip";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.all;
  };
})
