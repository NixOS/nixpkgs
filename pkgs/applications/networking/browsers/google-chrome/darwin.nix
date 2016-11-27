{ stdenv, lib, fetchurl, undmg, chromium }:

with lib;

with chromium.upstream-info;

stdenv.mkDerivation rec {
  inherit version;

  name = "google-chrome-${version}";

  src = fetchurl {
    url = "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg";
    sha256 = "15yzac36av54hs8jfp1wbqgv8c7sxwf1cj0vbk8sdx8xf8mpax4x";
  };

  buildInputs = [ undmg ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -r . $out/Applications/"Google Chrome.app"
  '';

  meta = {
    description = "A freeware web browser developed by Google";
    homepage = https://www.google.com/chrome/browser/;
    license = licenses.unfree;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.darwin;
  };
}
