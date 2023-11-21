{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, ffmpeg
, fftwFloat
, chafa
, freeimage
, glib
, opusfile
, libopus
, libvorbis
}:

stdenv.mkDerivation rec {
  pname = "kew";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v${version}";
    hash = "sha256-WdWeC9Bx7gI55pDtpORVAeld8QWo6BMzxQ/bliSAFII=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg freeimage libvorbis opusfile libopus fftwFloat chafa glib ];
  buildFlags = "-I${opusfile.dev}/include/opus";

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "A command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    mainProgram = "kew";
    maintainers = with maintainers; [ demine ];
  };
}
