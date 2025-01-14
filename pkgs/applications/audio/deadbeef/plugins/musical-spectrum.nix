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

stdenv.mkDerivation rec {
  pname = "deadbeef-musical-spectrum-plugin";
  version = "unstable-2020-07-01";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = "ddb_musical_spectrum";
    rev = "a97fd4e1168509911ab43ba32d815b5489000a06";
    sha256 = "0p33wyqi27y0q1mvjv5nn6l3vvqlg6b8yd6k2l07bax670bl0q3g";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    fftw
    glib
    gtk3
  ];
  makeFlags = [ "gtk3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef
    install -v -c -m 644 gtk3/ddb_vis_musical_spectrum_GTK3.so $out/lib/deadbeef/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Musical spectrum plugin for the DeaDBeeF music player";
    homepage = "https://github.com/cboxdoerfer/ddb_musical_spectrum";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ddelabru ];
  };
}
