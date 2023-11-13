{ lib
, stdenv
, fetchFromGitHub
, ffmpeg
, fftwFloat
, chafa
, freeimage
, glib
, pkg-config
}:

stdenv.mkDerivation {
  pname = "kew";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v1.5.2";
    hash = "sha256-Om7v8eTlYxXQYf1MG+L0I5ICQ2LS7onouhPGosuK8NM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg freeimage fftwFloat.dev chafa glib.dev ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}/bin"
  ];

  meta = {
    description = "kew is a command-line music player for Linux.";
    homepage = "https://github.com/ravachol/kew";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ demine ];
  };
}
