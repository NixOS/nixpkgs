{ lib, stdenv, mkDerivation, fetchFromGitHub
, qmake, pkg-config, olm, wrapQtAppsHook
, qtbase, qtquickcontrols2, qtkeychain, qtmultimedia, qttools, qtgraphicaleffects
, python3Packages, pyotherside, libXScrnSaver
}:

let
  pypkgs = with python3Packages; [
    aiofiles filetype matrix-nio appdirs cairosvg
    pymediainfo setuptools html-sanitizer mistune
    pyotherside plyer sortedcontainers watchgod
    redbaron hsluv simpleaudio dbus-python
  ];
in
mkDerivation rec {
  pname = "mirage";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mirukana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MAXjZoW4qfV4OI964gGQs5ZBJIn9gmvQCi6FnEKeKWM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook python3Packages.wrapPython ];

  buildInputs = [
    qtbase qtmultimedia
    qtquickcontrols2
    qtkeychain qtgraphicaleffects
    olm pyotherside
    libXScrnSaver
  ];

  propagatedBuildInputs = pypkgs;

  pythonPath = pypkgs;

  qmakeFlags = [ "PREFIX=${placeholder "out"}" "CONFIG+=qtquickcompiler" ];

  dontWrapQtApps = true;
  postInstall = ''
    buildPythonPath "$out $pythonPath"
    wrapProgram $out/bin/mirage \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      "''${qtWrapperArgs[@]}"
    '';

  meta = with lib; {
    description = "A fancy, customizable, keyboard-operable Qt/QML+Python Matrix chat client for encrypted and decentralized communication";
    homepage = "https://github.com/mirukana/mirage";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ colemickens ];
    broken = stdenv.isDarwin;
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
