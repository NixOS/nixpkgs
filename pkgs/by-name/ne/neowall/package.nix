{
  stdenv,
  pkg-config,
  fetchFromGitHub,
  lib,
  libGL,
  libx11,
  libxrandr,
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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hmfHcKXDmMHlFlaODo+BrbHUyx9BHn9BiCbPDp5CMG0=";
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
    libx11
    libxrandr
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
