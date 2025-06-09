{
  lib,
  stdenv,
  fetchFromGitHub,
  deadbeef,
  pkg-config,
  gtk3,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "deadbeef-waveform-seekbar-plugin";
  version = "0-unstable-2024-11-13";

  src = fetchFromGitHub {
    owner = "Jbsco";
    repo = "ddb_waveform_seekbar";
    rev = "2e5ea867a77e37698524d22f41fc59ffae16e63d";
    hash = "sha256-m6lBF+Yq1gah6kjb9VvIsjVg1i++08JPLzcLLMt+8J8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    gtk3
    sqlite
  ];
  makeFlags = [ "gtk3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef/
    install -v -c -m 644 gtk3/ddb_misc_waveform_GTK3.so $out/lib/deadbeef/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Waveform Seekbar plugin for DeaDBeeF audio player";
    homepage = "https://github.com/cboxdoerfer/ddb_waveform_seekbar";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.deudz ];
  };
}
