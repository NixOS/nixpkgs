{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logitune";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mmaher88";
    repo = "logitune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zyALn1mOdQoUPj5j045pvCQjffQB6Rl/+QyKziCqixw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    systemd
  ];

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=OFF"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Configure Logitech devices on Linux (Options+ clone)";
    homepage = "https://github.com/mmaher88/logitune";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.garrettgr ];
    platforms = with lib.platforms; linux;
    mainProgram = "logitune";
  };
})
