{
  stdenv,
  pkg-config,
  fetchFromGitHub,
  lib,
  libGL,
  libX11,
  libXrandr,
  libpng,
  libjpeg,
  wayland,
  wayland-scanner,
  wayland-protocols,
  versionCheckHook,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neowall";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-esI7m5V6ISpoXllLNjb52TdVMKel4FKOKPa40n3rofo=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    meson
    ninja
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libX11
    libXrandr
    libGL
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
