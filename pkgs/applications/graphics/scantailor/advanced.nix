{ stdenv, fetchFromGitHub, makeDesktopItem
, cmake, libjpeg, libpng, libtiff, boost
, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "scantailor-advanced-${version}";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "4lex4";
    repo = "scantailor-advanced";
    rev = "v${version}";
    sha256 = "031jqk64ig6lmscl5yg5lp116zwn0jl7xs9rlniqf6a8g4wfbjk9";
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
    platforms = platforms.gnu ++ platforms.linux;
  };
}
