{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation {
  pname = "sequel-pro";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/sequelpro/sequelpro/releases/download/release-1.1.2/sequel-pro-1.1.2.dmg";
    sha256 = "1il7yc3f0yzxkra27bslnmka5ycxzx0q4m3xz2j9r7iyq5izsd3v";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/Sequel Pro.app"
    cp -R . "$out/Applications/Sequel Pro.app"
    chmod +x "$out/Applications/Sequel Pro.app/Contents/MacOS/Sequel Pro"
  '';

  meta = {
    description = "MySQL database management for macOS";
    homepage = "http://www.sequelpro.com/";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
