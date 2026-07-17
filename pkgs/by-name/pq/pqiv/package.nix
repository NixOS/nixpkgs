{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  gtk3,
  imagemagick,
  libarchive,
  libspectre,
  libwebp,
  poppler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pqiv";
  version = "2.13.3";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    tag = finalAttrs.version;
    hash = "sha256-A02YB2VJ3gajnUqzkvmGUGQrEU5XIMSnHS1HLmPnN00=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ffmpeg
    gtk3
    imagemagick
    libarchive
    libspectre
    libwebp
    poppler
  ];

  prePatch = "patchShebangs .";

  meta = {
    description = "Powerful image viewer with minimal UI";
    homepage = "https://www.pberndt.com/Programme/Linux/pqiv";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.unix;
    mainProgram = "pqiv";
  };
})
