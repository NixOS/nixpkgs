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
  version = "1.0.0-alpha.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "epoch-${version}";
    hash = "sha256-4++wCyRVIodWdlrvK2vMcHGoY4BctnrkopWC6dZvhMk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0KXo1wtbbnK3Kk+EGZo7eEecM4PChLpwawWWI0Bp/Yw=";

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-09-24";
  env.VERGEN_GIT_SHA = src.rev;

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
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

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/cosmic-term" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
        ]
      }
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
