{
  lib,
  cosmic-icons,
  fetchFromGitHub,
  fontconfig,
  freetype,
  just,
  libglvnd,
  libinput,
  libxkbcommon,
  makeBinaryWrapper,
  pkg-config,
  rustPlatform,
  stdenv,
  vulkan-loader,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "epoch-${version}";
    hash = "sha256-uPKbh1PA8P51Gcet459ZBRKRe0JmxSWvIFn3AQIG6KY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-clGzp7pH7YHePFzlq2eLYKKx9IiFQKB5FmqPeuSuIVc=";

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
    fontconfig
    freetype
    libglvnd
    libinput
    libxkbcommon
    vulkan-loader
    wayland
    xorg.libX11
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
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
    wrapProgram "$out/bin/cosmic-term" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-term";
  };
}
