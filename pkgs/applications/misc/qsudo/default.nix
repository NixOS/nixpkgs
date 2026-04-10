{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  wrapQtAppsHook,
  qtbase,
  sudo,
}:

stdenv.mkDerivation rec {
  pname = "qsudo";
  version = "2020.03.27";

  src = fetchFromGitHub {
    owner = "project-trident";
    repo = "qsudo";
    rev = "v${version}";
    sha256 = "06kg057vwkvafnk69m9rar4wih3vq4h36wbzwbfc2kndsnn47lfl";
  };

  sourceRoot = "${src.name}/src-qt5";

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    sudo
  ];

  postPatch = ''
    substituteInPlace qsudo.pro --replace /usr/bin $out/bin
  '';

  meta = {
    description = "Graphical sudo utility from Project Trident";
    mainProgram = "qsudo";
    homepage = "https://github.com/project-trident/qsudo";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
