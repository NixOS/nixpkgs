{ stdenv, fetchFromGitHub, deadbeef, pkgconfig, glib, gtk3, sqlite }:

stdenv.mkDerivation rec {
  name = "deadbeef-waveform-seekbar-gtk3-plugin-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "cboxdoerfer";
    repo = "ddb_waveform_seekbar";
    rev = "v${version}";
    sha256 = "1v1schvnps7ypjqgcbqi74a45w8r2gbhrawz7filym22h1qr9wn0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ deadbeef glib gtk3 sqlite ];

  buildFlags = [ "gtk3" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/deadbeef
    cp gtk3/ddb_misc_waveform_GTK3.so $out/lib/deadbeef

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Waveform Seekbar plugin for DeaDBeeF audio player";
    homepage = https://github.com/cboxdoerfer/ddb_waveform_seekbar;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
