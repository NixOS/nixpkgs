{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libX11,
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
    libX11
    libxcb
    qt6.qtbase
  ];

  meta = with lib; {
    description = "Dock any application into the system tray";
    homepage = "https://github.com/user-none/KDocker";
    changelog = "https://github.com/user-none/KDocker/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hexclover ];
    platforms = platforms.linux;
    mainProgram = "kdocker";
  };
})
