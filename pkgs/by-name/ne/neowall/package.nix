{
  stdenv,
  pkg-config,
  fetchFromGitHub,
  lib,
  libglvnd,
  mesa,
  libpng,
  libjpeg,
  wayland,
  wayland-scanner,
  versionCheckHook,
}:

stdenv.mkDerivation (finallAttrs: {
  pname = "neowall";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    tag = "v${finallAttrs.version}";
    hash = "sha256-q/M79ol4l4YIsewP50/6I2C5zKmF1Bc4mgIC896qxPY=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    mesa
    libglvnd
    libpng
    libjpeg
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/1ay1/neowall/releases/tag/${finallAttrs.src.tag}";
    description = "GPU shader wallpapers for Wayland";
    homepage = "https://github.com/1ay1/neowall";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
    mainProgram = "neowall";
  };
})
