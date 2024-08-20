{
  lib,
  stdenv,
  smartmontools,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "QDiskInfo";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "edisionnano";
    repo = "QDiskInfo";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-YLNpQOmh/exBJDuYRUEvzNv/El4x+PttEoj+aCur9wg=";
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

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=MinSizeRel"
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
