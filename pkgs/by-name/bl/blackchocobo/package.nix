{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  ff7tk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackchocobo";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "sithlord48";
    repo = "blackchocobo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PdxgGkXEvRbhZs52WLembJsGKi6boxIDRmVimKwwR7w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    ff7tk
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Save editor for Final Fantasy VII";
    homepage = "https://github.com/sithlord48/blackchocobo";
    changelog = "https://github.com/sithlord48/blackchocobo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "blackchocobo";
    platforms = lib.platforms.linux;
  };
})
