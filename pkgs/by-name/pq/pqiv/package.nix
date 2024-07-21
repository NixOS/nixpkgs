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
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "pqiv";
    rev = finalAttrs.version;
    hash = "sha256-Op+N4zzq7MazjFvx5VisjsRXbIqLtWPv4hdVjmS7lPY=";
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
