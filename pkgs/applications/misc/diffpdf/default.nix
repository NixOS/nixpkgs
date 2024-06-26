{
  lib,
  mkDerivation,
  fetchurl,
  fetchpatch,
  qmake,
  qttools,
  qtbase,
  poppler,
}:

mkDerivation rec {
  version = "2.1.3";
  pname = "diffpdf";

  src = fetchurl {
    url = "http://www.qtrac.eu/${pname}-${version}.tar.gz";
    sha256 = "0cr468fi0d512jjj23r5flfzx957vibc9c25gwwhi0d773h2w566";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/9b971631588ff46e7c2d501bc35cd0d9ce2d98e2/app-text/diffpdf/files/diffpdf-2.1.3-qt5.patch";
      sha256 = "0sax8gcqcmzf74hmdr3rarqs4nsxmml9qmh6pqyjmgl3lypxhafg";
    })
    ./fix_path_poppler_qt5.patch
  ];

  nativeBuildInputs = [
    qmake
    qttools
  ];
  buildInputs = [
    qtbase
    poppler
  ];

  preConfigure = ''
    substituteInPlace diffpdf.pro --replace @@NIX_POPPLER_QT5@@ ${poppler.dev}
    lrelease diffpdf.pro
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    install -Dpm755 -D diffpdf $out/bin/diffpdf
    install -Dpm644 -D diffpdf.1 $out/share/man/man1/diffpdf.1

    install -dpm755 $out/share/doc/${pname}-${version} $out/share/licenses/${pname}-${version} $out/share/icons $out/share/pixmaps $out/share/applications
    install -Dpm644 CHANGES README help.html $out/share/doc/${pname}-${version}/
    install -Dpm644 gpl-2.0.txt $out/share/licenses/${pname}-${version}/
    install -Dpm644 images/icon.png $out/share/pixmaps/diffpdf.png

    cat > $out/share/applications/diffpdf.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=diffpdf
    Icon=diffpdf
    Comment=PDF diffing tool
    Exec=$out/bin/diffpdf
    Terminal=false
    EOF
  '';

  meta = {
    homepage = "http://www.qtrac.eu/diffpdfc.html";
    description = "Tool for diffing pdf files visually or textually";
    mainProgram = "diffpdf";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
