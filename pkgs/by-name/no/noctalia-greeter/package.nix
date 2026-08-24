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
  librsvg,
  libwebp,
  libxkbcommon,
  nlohmann_json,
  pango,
  stb,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wlroots_0_20,

  nix-update-script,
}:

let
  # nixpkgs stb doesn't have stb_image_resize2.h which noctalia-greeter needs
  stb' = stb.overrideAttrs {
    version = "0-unstable-2025-10-26";
    src = fetchFromGitHub {
      owner = "nothings";
      repo = "stb";
      rev = "f1c79c02822848a9bed4315b12c8c8f3761e1296";
      hash = "sha256-BlyXJtAI7WqXCTT3ylww8zoG0hBxaojJnQDvdQOXJPE=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "noctalia-greeter";
  version = "1.2.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-greeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k/qCnifAoBqpHkRPYn6nUfEoRV1HXac01+Fh4aouWIE=";
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
    librsvg
    libwebp
    libxkbcommon
    nlohmann_json
    pango
    stb'
    tomlplusplus
    wayland
    wayland-protocols
    wlroots_0_20
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`greetd` greeter for Noctalia";
    homepage = "https://github.com/noctalia-dev/noctalia-greeter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dtomvan
      samiser
      spacedentist
    ];
    mainProgram = "noctalia-greeter-session";
    platforms = lib.platforms.linux;
  };
})
