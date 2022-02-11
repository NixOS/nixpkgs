{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, libXScrnSaver
, olm
, pkg-config
, pyotherside
, python3Packages
, qmake
, qtbase
, qtgraphicaleffects
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, wrapQtAppsHook
}:

mkDerivation rec {
  pname = "mirage";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mirukana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dJS4lAXHHNUEAG75gQaS9+aQTTTj8KHqHjISioynFdY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libXScrnSaver
    olm
    pyotherside
    qtbase
    qtgraphicaleffects
    qtkeychain
    qtmultimedia
    qtquickcontrols2
  ] ++ pythonPath;

  pythonPath = with python3Packages; [
    pillow
    aiofiles
    appdirs
    cairosvg
    filetype
    html-sanitizer
    lxml
    mistune
    pymediainfo
    plyer
    sortedcontainers
    watchgod
    redbaron
    hsluv
    simpleaudio
    setuptools
    watchgod
    dbus-python
  ];

  qmakeFlags = [
    "PREFIX=${placeholder "out"}"
    "CONFIG+=qtquickcompiler"
  ];

  dontWrapQtApps = true;
  postInstall = ''
    buildPythonPath "$out $pythonPath"
    wrapProgram $out/bin/mirage \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/mirukana/mirage";
    description = "A fancy, customizable, keyboard-operable Qt/QML+Python Matrix chat client for encrypted and decentralized communication";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ colemickens AndersonTorres ];
    inherit (qtbase.meta) platforms;
    broken = stdenv.isDarwin || python3Packages.isPy37 || python3Packages.isPy38;
  };
}
