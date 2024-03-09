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
  version = "2.13";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = finalAttrs.version;
    hash = "sha256-Jlc6sd9lRWUC1/2GZnJ0EmVRHxCXP8dTZNZEhJBS7oQ=";
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

  meta = with lib; {
    description = "Powerful image viewer with minimal UI";
    homepage = "https://www.pberndt.com/Programme/Linux/pqiv";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.linux;
    mainProgram = "pqiv";
  };
})
