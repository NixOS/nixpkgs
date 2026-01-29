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

stdenv.mkDerivation (finalAttrs: {
  pname = "geonkick";
  version = "3.7.0";

  src = fetchFromGitLab {
    owner = "Geonkick-Synthesizer";
    repo = "geonkick";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8FfgtqFfiO1CKp2t0uXbXEtH6C1bx1EJWagjCfDwIwY=";
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

  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "Free software percussion synthesizer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
    mainProgram = "geonkick";
  };
})
