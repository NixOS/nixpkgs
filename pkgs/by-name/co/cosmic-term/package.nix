{ lib
, cosmic-icons
, fetchFromGitHub
, fontconfig
, freetype
, just
, libglvnd
, libinput
, libxkbcommon
, makeBinaryWrapper
, pkg-config
, rustPlatform
, stdenv
, vulkan-loader
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "epoch-${version}";
    hash = "sha256-dY4QGQXJFL+yjCYRGCg3NfMLMjlEBSEmxHn68PvhCAQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-DgMh0gqWUmXjBhBySR0CMnv/8O3XbS2BwomU9eNt+4o=";
      "cosmic-files-0.1.0" = "sha256-QDkHhU0zE0szFwGuVuSYrXd7AUdTU1rYxlAsaHr2YvQ=";
      "cosmic-text-0.12.1" = "sha256-x0XTxzbmtE2d4XCG/Nuq3DzBpz15BbnjRRlirfNJEiU=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libc-0.2.154" = "sha256-/pkmpCxzRTjBiLFKauqUqGTBTxNUQX4zwPWYpDsjwVQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-08-03";
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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libxkbcommon
        vulkan-loader
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
      ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-term";
  };
}
