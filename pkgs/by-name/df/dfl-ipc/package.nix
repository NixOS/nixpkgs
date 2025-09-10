{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-ipc";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "ipc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GjQg7Fq7fWal1vh/jR5qqm+qs+D/McCoQfktOvO86eA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Very simple set of IPC classes for inter-process communication";
    homepage = "https://gitlab.com/desktop-frameworks/ipc";
    changelog = "https://gitlab.com/desktop-frameworks/ipc/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.linux;
  };
})
