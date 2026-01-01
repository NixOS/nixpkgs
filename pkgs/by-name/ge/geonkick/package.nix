{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libsndfile,
  rapidjson,
  libjack2,
  lv2,
  libX11,
  cairo,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "3.6.2";

  src = fetchFromGitLab {
    owner = "Geonkick-Synthesizer";
    repo = "geonkick";
    rev = "v${version}";
    hash = "sha256-1khlAY9szKdwX/kMJvuD1CTO5M8GeMBVCSPmt52GJyA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libsndfile
    rapidjson
    libjack2
    lv2
    libX11
    cairo
    openssl
  ];

  # Without this, the lv2 ends up in
  # /nix/store/$HASH/nix/store/$HASH/lib/lv2
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "Free software percussion synthesizer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
=======
  meta = with lib; {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "Free software percussion synthesizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "geonkick";
  };
}
