{ stdenv, fetchurl, qmake, qtsvg, makeWrapper, xdg_utils }:

let
  version = "1.44.55";
in stdenv.mkDerivation rec {
  name = "mytetra-${version}";
  src = fetchurl {
    url = "https://github.com/xintrea/mytetra_dev/archive/v.${version}.tar.gz";
    sha256 = "13lmfvschm1xwr0ys2ykhs0bb83m2f39rk1jdd7zf8yxlqki4i6l";
  };

  nativeBuildInputs = [ qmake makeWrapper ];
  buildInputs = [ qtsvg ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    substituteInPlace app/app.pro \
      --replace /usr/local/bin $out/bin \
      --replace /usr/share $out/share

    substituteInPlace app/src/views/mainWindow/MainWindow.cpp \
      --replace ":/resource/pic/logo.svg" "$out/share/icons/hicolor/48x48/apps/mytetra.png"
  '';

  postFixup = ''
    wrapProgram $out/bin/mytetra \
      --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "Smart manager for information collecting";
    homepage = https://webhamster.ru/site/page/index/articles/projectcode/138;
    license = licenses.gpl3;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
