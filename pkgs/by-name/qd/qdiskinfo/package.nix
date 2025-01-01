{
  lib,
  stdenv,
  smartmontools,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdiskinfo";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "edisionnano";
    repo = "QDiskInfo";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-0zF3Nc5K8+K68HOSy30ieYvYP9/oSkTe0+cp0hVo9Gs=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    smartmontools
  ];

  cmakeBuildType = "MinSizeRel";

  cmakeFlags = [
    "-DQT_VERSION_MAJOR=6"
  ];

  postInstall = ''
    wrapProgram $out/bin/QDiskInfo \
      --suffix PATH : ${smartmontools}/bin
  '';

  meta = {
    description = "CrystalDiskInfo alternative for Linux";
    homepage = "https://github.com/edisionnano/QDiskInfo";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ roydubnium ];
    platforms = lib.platforms.linux;
    mainProgram = "QDiskInfo";
  };
})
