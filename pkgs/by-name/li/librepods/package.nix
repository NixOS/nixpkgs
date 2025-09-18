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
  version = "0.1.0-rc.4";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FnDYQ3EPx2hpeCCZvbf5PJo+KCj+YO+DNg+++UpZ7Xs=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtmultimedia
    pulseaudio
  ];

  sourceRoot = "${finalAttrs.src.name}/linux";

  qtWrapperArgs = [ ''--prefix PATH : ${pulseaudio}/bin'' ];

  postInstall = ''
    mv $out/bin/{applinux,librepods}
  '';

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
