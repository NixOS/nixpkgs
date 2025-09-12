{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corefm";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corefm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VsnbWknkMJp/2MDXbJuEQomotGqTXhZcUvu+ODJOjdM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Lightwight filemanager from the C Suite";
    mainProgram = "corefm";
    homepage = "https://gitlab.com/cubocore/coreapps/corefm";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
