{ lib, mkDerivation, fetchFromGitHub
, qmake, pkgconfig, olm, wrapQtAppsHook
, qtbase, qtquickcontrols2, qtkeychain, qtmultimedia, qttools, qtgraphicaleffects
, python3Packages, pyotherside
}:

let
  pypkgs = with python3Packages; [
    aiofiles filetype matrix-nio appdirs cairosvg
    pymediainfo setuptools html-sanitizer mistune blist
    pyotherside
  ];
in
mkDerivation rec {
  pname = "mirage";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mirukana";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i891fafdncdz1xg6nji80jb86agsrbdvai9nwf1yy126q7piryv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig qmake wrapQtAppsHook python3Packages.wrapPython ];

  buildInputs = [
    qtbase qtmultimedia
    qtquickcontrols2
    qtkeychain qtgraphicaleffects
    olm pyotherside
  ];

  propagatedBuildInputs = pypkgs;

  pythonPath = pypkgs;

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

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
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
