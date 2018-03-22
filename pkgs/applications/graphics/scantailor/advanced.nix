{ stdenv, fetchFromGitHub, makeDesktopItem
, cmake, libjpeg, libpng, libtiff, boost
, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "scantailor-advanced-${version}";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "4lex4";
    repo = "scantailor-advanced";
    rev = "v${version}";
    sha256 = "0i80jzky7l8wdv0wqdx48x1q0wmj72hhm0050pd43q80pj5r78a0";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ libjpeg libpng libtiff boost qtbase ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $src/resources/appicon.svg $out/share/icons/hicolor/scalable/apps/scantailor.svg

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/
    for entry in $out/share/applications/*.desktop; do
      substituteAllInPlace $entry
    done
  '';

  desktopItem = makeDesktopItem {
    name = "scantailor-advanced";
    exec = "scantailor %f";
    icon = "scantailor";
    comment = meta.description;
    desktopName = "Scan Tailor Advanced";
    genericName = "Scan Processing Software";
    mimeType = "image/png;image/tif;image/jpeg;";
    categories = "Graphics;";
    startupNotify = "true";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/4lex4/scantailor-advanced;
    description = "Interactive post-processing tool for scanned pages";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jfrankenau ];
    platforms = platforms.gnu;
  };
}
