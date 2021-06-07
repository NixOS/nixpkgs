{ mkDerivation
, cmark-gfm
, fetchurl
, qmake
, qtbase
, qtwebkit
, lib
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "mindforger";
  version = "1.52.0";

  src = fetchurl {
    url = "https://github.com/dvorka/mindforger/releases/download/${version}/mindforger_${version}.tgz";
    sha256 = "1pghsw8kwvjhg3jpmjs0n892h2l0pm0cs6ymi8b23fwk0kfj67rd";
  };

  nativeBuildInputs = [ qmake wrapGAppsHook ] ;
  buildInputs = [ qtbase qtwebkit cmark-gfm ] ;

  doCheck = true;

  patches = [ ./build.patch ] ;

  postPatch = ''
    substituteInPlace lib/src/install/installer.cpp --replace /usr "$out"
    substituteInPlace app/resources/gnome-shell/mindforger.desktop --replace /usr "$out"
  '';

  qmakeFlags = [ "-r mindforger.pro" "CONFIG+=mfnoccache" ] ;

  meta = with lib; {
    description = "Thinking Notebook & Markdown IDE";
    longDescription = ''
     MindForger is actually more than an editor or IDE - it's human
     mind inspired personal knowledge management tool
    '';
    homepage = "https://www.mindforger.com";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ cyplo ];
  };
}
