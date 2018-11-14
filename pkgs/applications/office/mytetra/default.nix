{ stdenv, fetchurl, qmake, qtsvg, makeWrapper, xdg_utils }:

let
  version = "1.43.27";
in stdenv.mkDerivation rec {
  name = "mytetra-${version}";
  src = fetchurl {
    url = "https://github.com/xintrea/mytetra_dev/archive/v.${version}.tar.gz";
    sha256 = "1gzr11jy1bvnp28w2ar3wmh76g55jn9nra5la5qasnal6b5pg28h";
  };

  nativeBuildInputs = [ qmake makeWrapper ];
  buildInputs = [ qtsvg ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    substituteInPlace mytetra.pro \
      --replace /usr/local/bin $out/bin \
      --replace /usr/share $out/share

    substituteInPlace src/views/mainWindow/MainWindow.cpp \
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
