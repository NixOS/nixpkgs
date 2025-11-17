{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  qt6,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-login1";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "login1";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Aw2yg5KH618/lG+BQU8JZhQ/8qr6L3vWiEgUNu7aGYY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    systemd
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Implementation of systemd/elogind for DFL";
    homepage = "https://gitlab.com/desktop-frameworks/login1";
    changelog = "https://gitlab.com/desktop-frameworks/login1/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.linux;
  };
})
