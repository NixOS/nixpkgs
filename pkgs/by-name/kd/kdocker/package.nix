{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libx11,
  libxcb,
  perl, # For pod2man
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdocker";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "user-none";
    repo = "KDocker";
    rev = "${finalAttrs.version}";
    hash = "sha256-ckTi/w2Yynsl3aJzV9Uxfc7WxJtcCt44glJyqEEZrig=";
  };

  nativeBuildInputs = [
    cmake
    perl
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libx11
    libxcb
    qt6.qtbase
  ];

  meta = {
    description = "Dock any application into the system tray";
    homepage = "https://github.com/user-none/KDocker";
    changelog = "https://github.com/user-none/KDocker/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ hexclover ];
    platforms = lib.platforms.linux;
    mainProgram = "kdocker";
  };
})
