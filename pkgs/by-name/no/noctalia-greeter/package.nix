{
  lib,
  stdenv,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,
  wayland-scanner,

  bashNonInteractive,
  cairo,
  fontconfig,
  freetype,
  glib,
  libGL,
  libjxl,
  librsvg,
  libwebp,
  libxkbcommon,
  libxml2,
  nlohmann_json,
  pango,
  stb,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wlroots_0_20,

  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noctalia-greeter";
  version = "1.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-greeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ILFIjvpGFxwt6y9GDESlNcVm2t0Q2Ku108vWiqCsWfM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    bashNonInteractive
    cairo
    fontconfig
    freetype
    glib
    libGL
    libjxl
    librsvg
    libwebp
    libxkbcommon
    libxml2
    nlohmann_json
    pango
    stb
    tomlplusplus
    wayland
    wayland-protocols
    wlroots_0_20
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  versionCheckProgram = "${placeholder "out"}/bin/noctalia-greeter";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`greetd` greeter for Noctalia";
    homepage = "https://github.com/noctalia-dev/noctalia-greeter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dtomvan
      pyrox0
      samiser
      spacedentist
    ];
    mainProgram = "noctalia-greeter-session";
    platforms = lib.platforms.linux;
  };
})
