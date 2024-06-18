{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, sudo
}:

mkDerivation rec {
  pname = "qsudo";
  version = "2020.03.27";

  src = fetchFromGitHub {
    owner = "project-trident";
    repo = pname;
    rev = "v${version}";
    sha256 = "06kg057vwkvafnk69m9rar4wih3vq4h36wbzwbfc2kndsnn47lfl";
  };

  sourceRoot = "${src.name}/src-qt5";

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    sudo
  ];

  postPatch = ''
    substituteInPlace qsudo.pro --replace /usr/bin $out/bin
  '';

  meta = with lib; {
    description = "Graphical sudo utility from Project Trident";
    mainProgram = "qsudo";
    homepage = "https://github.com/project-trident/qsudo";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
