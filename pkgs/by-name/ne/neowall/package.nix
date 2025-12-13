{
  stdenv,
  pkg-config,
  fetchFromGitHub,
  lib,
  libglvnd,
  mesa,
  libX11,
  libXrandr,
  libpng,
  libjpeg,
  wayland,
  wayland-scanner,
  wayland-protocols,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neowall";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wt9sNuUO2IIXlQAanDsWNjbqAaUH/jCzPoQYokl36OU=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    mesa
    libX11
    libXrandr
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
    changelog = "https://github.com/1ay1/neowall/releases/tag/${finalAttrs.src.tag}";
    description = "GPU shader wallpapers for Wayland";
    homepage = "https://github.com/1ay1/neowall";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lonerOrz ];
    mainProgram = "neowall";
  };
})
