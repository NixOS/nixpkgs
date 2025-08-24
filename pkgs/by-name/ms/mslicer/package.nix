{
  fetchFromGitHub,
  lib,
  libglvnd,
  libxkbcommon,
  nix-update-script,
  rustPlatform,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mslicer";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = finalAttrs.version;
    hash = "sha256-37EOdMM/stMKwTTpQ0LWYZVUw2Y3CkoEGHWNthyQnSA=";
  };

  cargoHash = "sha256-nkNoyoMqcFLCuQ8TqRn4e5L2zbgjw615HIAuLVqg0vQ=";

  buildInputs = [
    libglvnd
    libxkbcommon
    vulkan-loader
    wayland
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  NIX_LDFLAGS = [
    "--no-as-needed"
    "-lEGL"
    "-lvulkan"
    "-lwayland-client"
    "-lxkbcommon"
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental open source slicer for masked stereolithography (resin) printers";
    homepage = "https://connorcode.com/projects/mslicer";
    changelog = "https://github.com/connorslade/mslicer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
  };
})
