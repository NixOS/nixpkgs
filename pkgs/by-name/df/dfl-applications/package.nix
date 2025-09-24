{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  qt6,
  dfl-ipc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-applications";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "applications";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VDkJkrkhjWi61YD7qNQSF9/ctXtvVf+nh/zUVxAAE4Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    dfl-ipc
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Thin wrapper around QApplication, QGuiApplication and QCoreApplication";
    homepage = "https://gitlab.com/desktop-frameworks/applications";
    changelog = "https://gitlab.com/desktop-frameworks/applications/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.linux;
  };
})
