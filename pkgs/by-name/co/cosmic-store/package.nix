{ lib, stdenv, fetchFromGitHub, rustPlatform, appstream, makeBinaryWrapper
, cosmic-icons, glib, just, pkg-config, libglvnd, libxkbcommon, libinput
, fontconfig, flatpak, freetype, mesa, wayland, xorg, vulkan-loader
, vulkan-validation-layers, }:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "0-unstable-2024-01-22";
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "910e411c15fefdd5b118b3402441b20772bff042";
    hash = "sha256-ovKKCv3NpKoOBMLaDd49gwahB9mNr/kJGoLxluLm4/0=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" =
        "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" =
        "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" =
        "sha256-M2TRp0BmRb1tvLLUXeRdae/GBFz8FJsL8TukU6zXv/E=";
      "cosmic-text-0.10.0" =
        "sha256-S0GkKUiUsSkL1CZHXhtpQy7Mf5+6fqNuu33RRtxG3mE=";
      "glyphon-0.4.1" = "sha256-mwJXi63LTBIVFrFcywr/NeOJKfMjQaQkNl3CSdEgrZc=";
      "sctk-adwaita-0.5.4" =
        "sha256-yK0F2w/0nxyKrSiHZbx7+aPNY2vlFs7s8nu/COp2KqQ=";
      "softbuffer-0.3.3" =
        "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "smithay-client-toolkit-0.16.1" =
        "sha256-z7EZThbh7YmKzAACv181zaEZmWxTrMkFRzP0nfsHK6c=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.28.6" = "sha256-FhW6d2XnXCGJUMoT9EMQew9/OPXiehy/JraeCiVd76M=";
    };
  };

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ just pkg-config makeBinaryWrapper ];
  buildInputs = [
    appstream
    glib
    libxkbcommon
    libinput
    libglvnd
    fontconfig
    flatpak
    freetype
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
    wrapProgram "$out/bin/${pname}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          libxkbcommon
          vulkan-loader
          mesa.drivers
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary ];
    platforms = platforms.linux;
  };
}
