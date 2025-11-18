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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = finalAttrs.version;
    hash = "sha256-k/LoJ+GqtVHZab5BEXQ5k2SJkM9hwbOkPA6c+3i9Ylo=";
  };

  cargoHash = "sha256-a+nIVDjR+7Bh36GPNtWqKQvQgNo0w3KHWPmYpU7WMkM=";

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
