{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  sudo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qsudo";
  version = "2020.03.27";

  src = fetchFromGitHub {
    owner = "project-trident";
    repo = "qsudo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1NFDrNXNTsHc4n9xMyDBe8DISVY51WSmdWpPvk8Bbxo=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-qt5";

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
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
})
