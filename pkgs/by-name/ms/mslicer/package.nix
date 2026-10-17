{
  fetchFromGitHub,
  lib,
  libglvnd,
  libxkbcommon,
  nix-update-script,
  rustPlatform,
  vulkan-loader,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mslicer";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qAWUSjfhz4iQ5JkFoxTPP3hQZ9q4i7Gtx4tmfgk5YvY=";
  };

  cargoHash = "sha256-g1RDUqmVjqvzh32B7m8zA6JmP4bsHKqptGzNoH0QzT8=";

  buildInputs = [
    libglvnd
    libxkbcommon
    vulkan-loader
    wayland
    libxcursor
    libxrandr
    libxi
    libx11
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  env.NIX_LDFLAGS = toString [
    "--push-state"
    "--no-as-needed"
    "-lEGL"
    "-lvulkan"
    "-lwayland-client"
    "-lxkbcommon"
    "-lX11"
    "-lXcursor"
    "-lXrandr"
    "-lXi"
    "--pop-state"
  ];

  cargoBuildFlags = [
    "--package"
    "mslicer"
    "--package"
    "slicer"
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "mslicer";
    description = "High-performance, open-source slicer for MSLA resin printers";
    homepage = "https://mslicer.com";
    changelog = "https://github.com/connorslade/mslicer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
  };
})
