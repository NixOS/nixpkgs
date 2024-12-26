{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  appstream,
  makeBinaryWrapper,
  cosmic-icons,
  glib,
  just,
  pkg-config,
  libglvnd,
  libxkbcommon,
  libinput,
  fontconfig,
  flatpak,
  freetype,
  openssl,
  wayland,
  xorg,
  vulkan-loader,
  vulkan-validation-layers,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "epoch-${version}";
    hash = "sha256-mq94ZMVOdXAPR52ID5x8nppJ9mNoTOPBfn7Eouj3T1U=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lhMMzT6igjEEvwpcc7d8JyyHU0DcWVIh3z9KR6eCv7c=";

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    appstream
    glib
    libxkbcommon
    libinput
    libglvnd
    fontconfig
    flatpak
    freetype
    openssl
    xorg.libX11
    wayland
    vulkan-loader
    vulkan-validation-layers
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
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

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/cosmic-store" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          vulkan-loader
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = platforms.linux;
  };
}
