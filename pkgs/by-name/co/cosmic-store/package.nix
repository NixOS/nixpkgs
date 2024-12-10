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
  mesa,
  wayland,
  xorg,
  vulkan-loader,
  vulkan-validation-layers,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "unstable-2024-04-14";
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "b1bbeaa6e6bdc85c84d329ae01b69d72716411fc";
    hash = "sha256-KHYcQnaRFoYzl/00mFkS6MJS7Th0T0fQhxYUErjzGCo=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "appstream-0.2.2" = "sha256-Qb/zzZJ2sM97nGVtp8amecTlwuaDrx1cacDcZOwhUm8=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-config-0.1.0" = "sha256-Ps2QIzlwgW8ENB+uD6cOjCkjlZvmWspazsXNxDFCu7g=";
      "cosmic-text-0.11.2" = "sha256-K9cZeClr1zz4LanJS0WPEpxAplQrXfCjFKrSn5n4rDA=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

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
    maintainers = with maintainers; [
      ahoneybun
      nyanbinary
    ];
    platforms = platforms.linux;
  };
}
