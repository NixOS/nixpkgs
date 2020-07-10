{ mkDerivation
, lib
, fetchFromGitHub
, qmake
, makeWrapper
, qtquickcontrols2
, pyotherside
, qtgraphicaleffects
, python3Packages
}:

mkDerivation rec {
  pname = "mirage";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mirukana";
    repo = "mirage";
    rev = "v${version}";
    sha256 = "15kcac92h82vina3rn08m35y71h7h76hkyys42sa95hxbl3gpi21";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake makeWrapper python3Packages.wrapPython ];
  buildInputs = [
    qtquickcontrols2
    pyotherside
    qtgraphicaleffects
  ];
  pythonPath = with python3Packages; [
    aiofiles
    filetype
    matrix-nio
    appdirs
    cairosvg
    pymediainfo
    setuptools
    html-sanitizer
    mistune
    blist
  ];

  postInstall = ''
    buildPythonPath "$pythonPath"
    wrapProgram $out/bin/mirage --prefix PYTHONPATH : "$program_PYTHONPATH"
  '';


  meta = with lib; {
    description = "A fancy, customizable, keyboard-operable Matrix chat client for encrypted and decentralized communication.";
    homepage = "https://github.com/mirukana/mirage";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ atemu ];
  };
}
