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

stdenv.mkDerivation rec {
  pname = "kew";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v${version}";
    hash = "sha256-Om7v8eTlYxXQYf1MG+L0I5ICQ2LS7onouhPGosuK8NM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg freeimage fftwFloat chafa glib ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "A command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ demine ];
    mainProgram = "kew";
  };
}
