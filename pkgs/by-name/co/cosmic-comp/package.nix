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

  useFetchCargoVendor = true;
  cargoHash = "sha256-4ahdQ0lQbG+lifGlsJE0yci4j8pR7tYVsMww9LyYyAA=";

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
