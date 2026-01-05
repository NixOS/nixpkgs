{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngcheck";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "pnggroup";
    repo = "pngcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1cBcSCkiJmHVgYVCY5Em1UtiyAXgd6djEAChrXptTQM";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = {
    homepage = "https://www.libpng.org/pub/png/apps/pngcheck.html";
    description = "Verifies the integrity of PNG, JNG and MNG files";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ starcraft66 ];
    mainProgram = "pngcheck";
  };
})
