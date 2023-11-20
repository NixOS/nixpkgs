{ lib
, stdenv
, cmark-gfm
, fetchurl
, fetchpatch
, qmake
, qtbase
, qtwebengine
, wrapGAppsHook
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mindforger";
  version = "1.52.0";

  src = fetchurl {
    url = "https://github.com/dvorka/mindforger/releases/download/${version}/mindforger_${version}.tgz";
    sha256 = "1pghsw8kwvjhg3jpmjs0n892h2l0pm0cs6ymi8b23fwk0kfj67rd";
  };

  nativeBuildInputs = [ qmake wrapGAppsHook wrapQtAppsHook ];
  buildInputs = [ qtbase qtwebengine cmark-gfm ];

  doCheck = true;

  patches = [
    # this makes the package relocatable - removes hardcoded references to /usr
    ./paths.patch
    #  this fixes compilation with QtWebEngine - referencing a commit trying to upstream the change - see https://github.com/dvorka/mindforger/pull/1357
    (fetchpatch {
      url = "https://github.com/dvorka/mindforger/commit/d28e2bade0278af1b5249953202810540969026a.diff";
      sha256 = "sha256-qHKQQNGSc3F9seaOHV0gzBQFFqcTXk91LpKrojjpAUw=";
    })
  ];

  postPatch = ''
    substituteInPlace lib/src/install/installer.cpp --replace /usr "$out"
    substituteInPlace app/resources/gnome-shell/mindforger.desktop --replace /usr "$out"
    for f in app/app.pro lib/lib.pro; do
      substituteInPlace "$f" --replace "QMAKE_CXX = g++" ""
    done
  '';

  qmakeFlags = [
    "-r"
    "mindforger.pro"
    "CONFIG+=mfnoccache"
    "CONFIG+=mfwebengine"
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir "$out"/Applications
    mv app/mindforger.app "$out"/Applications/
  '';

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
