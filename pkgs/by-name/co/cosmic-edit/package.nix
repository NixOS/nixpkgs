{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  cosmic-icons,
  just,
  pkg-config,
  libglvnd,
  libxkbcommon,
  libinput,
  fontconfig,
  freetype,
  libgbm,
  wayland,
  xorg,
  vulkan-loader,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-edit";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "epoch-${version}";
    hash = "sha256-pxGV7X6FkYAtj4oj+XBWbi9evZ8J7Ng4sX7xbHDIJUg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6Ik3GhWsMwGADlbP09gf4RD0mT1zi9F+PNR89Co/LkU=";

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2025-01-14";
  env.VERGEN_GIT_SHA = src.rev;

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    xorg.libX11
    libinput
    libglvnd
    fontconfig
    freetype
    libgbm
    wayland
    vulkan-loader
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  postInstall = ''
    wrapProgram "$out/bin/cosmic-edit" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    mainProgram = "cosmic-edit";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = platforms.linux;
  };
}
