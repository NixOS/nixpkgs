{ stdenv, fetchurl, qmake, qtsvg }:

let
  version = "1.42.2";
in stdenv.mkDerivation rec {
  name = "mytetra-${version}";
  src = fetchurl {
    url = "https://github.com/xintrea/mytetra_dev/archive/v.${version}.tar.gz";
    sha256 = "1ah44nf4ksxkh01a2zmgvvby4pwczhyq5vcp270rf6visp8v9804";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtsvg ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    substituteInPlace mytetra.pro \
      --replace /usr/local/bin $out/bin \
      --replace /usr/share $out/share

    substituteInPlace src/views/mainWindow/MainWindow.cpp \
      --replace ":/resource/pic/logo.svg" "$out/share/icons/hicolor/48x48/apps/mytetra.png"
  '';

  meta = with stdenv.lib; {
    description = "Smart manager for information collecting";
    homepage = http://webhamster.ru/site/page/index/articles/projectcode/138;
    license = licenses.gpl3;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
