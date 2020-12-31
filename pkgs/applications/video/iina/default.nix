{ stdenv, fetchurl, undmg }:

stdenv.mkDerivation {
  pname = "iina";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v1.0.7-beta2/IINA.v1.0.7-beta2.dmg";
    sha256 = "1w0l3b1kar9zglqkildcqhlwara6zy2p3x79kqa2d0b43nqka82n";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/IINA.app"
    cp -R . "$out/Applications/IINA.app"
    chmod +x "$out/Applications/IINA.app/Contents/MacOS/IINA"
  '';

  meta = with stdenv.lib; {
    description = "The modern video player for macOS.";
    homepage = "http://https://iina.io/";
    license = licenses.gpl3;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ mic92 ];
  };
}
