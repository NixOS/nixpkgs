{ stdenv, fetchgit, alsaLib, fftw }:

stdenv.mkDerivation rec {
  name = "cava-${version}";
  version = "27dbdf47daae44c780db9998c760007b3bf63738";

  buildInputs = [ alsaLib fftw ];

  src = fetchgit {
    url = "https://github.com/karlstav/cava";
    rev = version;
    sha256 = "1a61e2c869376276cf78e6446cd1cc7f96b3e378fa8bc0bc4c5ca81945429909";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp cava $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = https://github.com/karlstav/cava;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
