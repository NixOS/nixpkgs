{
  deadbeef,
  fetchFromGitHub,
  fftw,
  glib,
  gtk3,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "deadbeef-musical-spectrum-plugin";
  version = "0-unstable-2020-07-01";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = "ddb_musical_spectrum";
    rev = "a97fd4e1168509911ab43ba32d815b5489000a06";
    hash = "sha256-b2BAFzimq3UAFdM0j5Z5FO89qLG2bLlrwMAfEbHnY1w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    fftw
    glib
    gtk3
  ];
  makeFlags = [ "gtk3" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-incompatible-pointer-types";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef
    install -v -c -m 644 gtk3/ddb_vis_musical_spectrum_GTK3.so $out/lib/deadbeef/

    runHook postInstall
  '';

  meta = {
    description = "Musical spectrum plugin for the DeaDBeeF music player";
    homepage = "https://github.com/cboxdoerfer/ddb_musical_spectrum";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ddelabru ];
  };
}
