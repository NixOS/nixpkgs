{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calaos_installer";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "calaos";
    repo = "calaos_installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e/f58VtGmKukdv4rIrGljXhA9d/xUycM5V6I1FT5qeY=";
  };

  buildInputs = [ libsForQt5.qtbase ];
  nativeBuildInputs = with libsForQt5; [
    qmake
    wrapQtAppsHook
    qttools
  ];

  qmakeFlags = [ "REVISION=${finalAttrs.version}" ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        cp -a calaos_installer.app $out/Applications
      ''
    else
      ''
        mkdir -p $out/bin
        cp -a calaos_installer $out/bin
      '';

  meta = {
    description = "Calaos Installer, a tool to create calaos configuration";
    mainProgram = "calaos_installer";
    homepage = "https://www.calaos.fr/";
    downloadPage = "https://github.com/calaos/calaos_installer/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tiramiseb ];
  };
})
