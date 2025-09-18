{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pulseaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "librepods";
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pD/Jb/wV91RlsiGl3SnGvQ11GNX37Y//CQHpIRyM/58=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtmultimedia
  ];

  sourceRoot = "${finalAttrs.src.name}/linux";

  postPatch = ''
    substituteInPlace autostartmanager.hpp --replace-fail "QString appPath = QCoreApplication::applicationFilePath();" "QString appPath = \"$out/bin/librepods\";"
  '';

  qtWrapperArgs = [ ''--prefix PATH :  ${lib.makeBinPath [ pulseaudio ]}'' ];

  meta = {
    description = "AirPods libreated from Apple’s ecosystem";
    homepage = "https://github.com/kavishdevar/librepods";
    changelog = "https://github.com/kavishdevar/librepods/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "librepods";
    platforms = lib.platforms.linux;
  };
})
