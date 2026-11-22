{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libremines";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Bollos00";
    repo = "libremines";
    tag = "v${finalAttrs.version}";
    hash = "sha256-12Vfk3NugDfmq3PIVU1arU92QRYurbIxa1f/LqsqAGk=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6Packages.qtwayland
  ];

  cmakeFlags = [ "-DUSE_QT6=TRUE" ];

  meta = {
    description = "Qt based Minesweeper game";
    mainProgram = "libremines";
    longDescription = ''
      A Free/Libre and Open Source Software Qt based Minesweeper game available for GNU/Linux, FreeBSD and Windows systems.
    '';
    homepage = "https://bollos00.github.io/LibreMines";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
