{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pixman,
  pkg-config,
  libinput,
  libglvnd,
  libxkbcommon,
  mesa,
  seatd,
  udev,
  xwayland,
  wayland,
  xorg,
  useXWayland ? true,
  systemd,
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-comp";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "epoch-${version}";
    hash = "sha256-IbGMp+4nRg4v5yRvp3ujGx7+nJ6wJmly6dZBXbQAnr8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-MZLjSIhPz+cpaSHA1R1S+9FD60ys+tHaJ+2Cz+2B/uE=";
      "cosmic-protocols-0.1.0" = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
      "cosmic-settings-config-0.1.0" = "sha256-j4tAclYoenNM+iBwk8iHOj4baIXc4wkclPl5RZsADGI=";
      "cosmic-text-0.12.1" = "sha256-3opGta6Co8l+hIQRVGkfSy6IqJXq/N8ZzqF+YGQADmI=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "iced-0.12.0" = "sha256-1RSl5Zd6pkSdAD0zkjL8mzgBbCuc0AE564uI8zrNCyc=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-vep0/Hv1E5YvnHFV91+4Y3CTxOYCAndEnguw/XJ3sNM=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "smithay-egui-0.1.0" = "sha256-i8Rlo221v8G7QUAVVBtBNdOtQv1Drv2oj+EhTBak25g=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libinput
    libxkbcommon
    mesa
    pixman
    seatd
    udev
    wayland
  ] ++ lib.optional useSystemd systemd;

  # Only default feature is systemd
  buildNoDefaultFeatures = !useSystemd;

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  makeFlags = [
    "prefix=$(out)"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  dontCargoInstall = true;

  # These libraries are only used by the X11 backend, which will not
  # be the common case, so just make them available, don't link them.
  postInstall =
    ''
      wrapProgramArgs=(--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXcursor
          xorg.libXi
        ]
      })
    ''
    + lib.optionalString useXWayland ''
      wrapProgramArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
    ''
    + ''
      wrapProgram $out/bin/cosmic-comp "''${wrapProgramArgs[@]}"
    '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    mainProgram = "cosmic-comp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      qyliss
      nyabinary
    ];
    platforms = platforms.linux;
  };
}
