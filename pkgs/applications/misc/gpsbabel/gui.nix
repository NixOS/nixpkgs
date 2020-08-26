{ stdenv, mkDerivation, qmake, qttools, qtwebkit, qttranslations, gpsbabel }:

mkDerivation {
  pname = "gpsbabel-gui";

  inherit (gpsbabel) src version;

  sourceRoot = "source/gui";

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtwebkit ];

  postPatch = ''
    substituteInPlace mainwindow.cc \
      --replace "QApplication::applicationDirPath() + \"/" "\"" \
      --replace "QApplication::applicationDirPath() + '/' + " "" \
      --replace "translator.load(full_filename)" "translator.load(filename)" \
      --replace "gpsbabelfe_%1.qm" "$out/share/gpsbabel/translations/gpsbabelfe_%1.qm" \
      --replace "gpsbabel_%1.qm" "$out/share/gpsbabel/translations/gpsbabel_%1.qm" \
      --replace "qt_%1.qm" "${qttranslations}/translations/qt_%1.qm"
    substituteInPlace formatload.cc \
      --replace "QApplication::applicationDirPath() + \"/" "\""
    substituteInPlace gpsbabel.desktop \
      --replace "gpsbabelfe-bin" "gpsbabelfe"
  '';

  preConfigure = ''
    lrelease *.ts coretool/*.ts
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${stdenv.lib.makeBinPath [ gpsbabel ]}"
  ];

  postInstall = ''
    install -Dm755 objects/gpsbabelfe -t $out/bin
    install -Dm644 gpsbabel.desktop -t $out/share/applications
    install -Dm644 images/appicon.png $out/share/icons/hicolor/512x512/apps/gpsbabel.png
    install -Dm644 *.qm coretool/*.qm -t $out/share/gpsbabel/translations
  '';

  meta = with stdenv.lib; {
    description = "Qt-based GUI for gpsbabel";
    homepage = "http://www.gpsbabel.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux;
  };
}
