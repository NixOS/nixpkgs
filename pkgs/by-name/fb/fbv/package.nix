{
  lib,
  stdenv,
  fetchFromGitHub,
  getopt,
  libjpeg,
  libpng12,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbv";
  version = "1.0c";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "fbv";
    tag = finalAttrs.version;
    hash = "sha256-4tAIFklKsx2uI+FQjq9vdolYm6d6YWugioG6k2ZUMrs=";
  };

  buildInputs = [
    getopt
    libjpeg
    libpng12
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,man/man1}
  '';

  meta = {
    description = "View pictures on a linux framebuffer device";
    homepage = "https://github.com/jstkdng/fbv";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "fbv";
  };
})
