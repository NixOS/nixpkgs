{ stdenv, mkDerivation, fetchFromGitHub
, qmake, pkgconfig, olm, wrapQtAppsHook
, qtbase, qtquickcontrols2, qtkeychain, qtmultimedia, qttools, qtgraphicaleffects
, python3Packages, pyotherside, libXScrnSaver
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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "mirukana";
    repo = pname;
    rev = "v${version}";
    sha256 = "15x0x2rf4fzsd0zr84fq3j3ddzkgc5il8s54jpxk8wl4ah03g4nv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig qmake wrapQtAppsHook python3Packages.wrapPython ];

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

  meta = with stdenv.lib; {
    description = "A fancy, customizable, keyboard-operable Qt/QML+Python Matrix chat client for encrypted and decentralized communication";
    homepage = "https://github.com/mirukana/mirage";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ colemickens ];
    broken = stdenv.isDarwin;
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
