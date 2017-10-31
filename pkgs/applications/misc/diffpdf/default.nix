{ stdenv, fetchurl, qt4, poppler_qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  version = "2.1.3";
  name = "diffpdf-${version}";

  src = fetchurl {
    url = "http://www.qtrac.eu/${name}.tar.gz";
    sha256 = "0cr468fi0d512jjj23r5flfzx957vibc9c25gwwhi0d773h2w566";
  };

  patches = [ ./fix_path_poppler_qt4.patch ];

  buildInputs = [ qt4 poppler_qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  preConfigure = ''
    substituteInPlace diffpdf.pro --replace @@NIX_POPPLER_QT4@@ ${poppler_qt4.dev}
    lrelease diffpdf.pro
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    install -Dpm755 -D diffpdf $out/bin/diffpdf
    install -Dpm644 -D diffpdf.1 $out/share/man/man1/diffpdf.1

    install -dpm755 $out/share/doc/${name} $out/share/licenses/${name} $out/share/icons $out/share/pixmaps $out/share/applications
    install -Dpm644 CHANGES README help.html $out/share/doc/${name}/
    install -Dpm644 gpl-2.0.txt $out/share/licenses/${name}/
    install -Dpm644 images/icon.png $out/share/icons/diffpdf.png
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
    homepage = http://www.qtrac.eu/diffpdfc.html;
    description = "Tool for diffing pdf files visually or textually";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
