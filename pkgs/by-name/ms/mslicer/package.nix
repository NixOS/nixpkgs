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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = finalAttrs.version;
    hash = "sha256-kDpV9UlqiqV+/h0PWk6fsOWumCHben4gkQk1mEXE5wk=";
  };

  cargoHash = "sha256-o1igInyC0N8TorQ/naKbRyTTdZiaSNquVy0i0jzNcAk=";

  postPatch = ''
    patchShebangs --build dist/msla_format/generate.sh
  '';

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

  # Build all binaries (e.g. the cli `slicer`) -- not just the default `mslicer` GUI application:
  cargoBuildFlags = [ "--workspace" ];

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
