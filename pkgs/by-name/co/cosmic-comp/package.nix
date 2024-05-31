{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, pkg-config
, libinput
, libglvnd
, libxkbcommon
, mesa
, seatd
, udev
, xwayland
, wayland
, xorg
, useXWayland ? true
, systemd
, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "d051d141979820f50b75bd686c745fb7f84fcd05";
    hash = "sha256-8okRiVVPzmuPJjnv1YoQPQFI8g0j1DQhwUoO51dHgGA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-config-0.1.0" = "sha256-5WajbfcfCc0ZRpJfysqEydthOsF04ipb35QVWuWKrEs=";
      "cosmic-protocols-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-e6BSrsrVSBcOuF8m21m74h7DWZnYHGIYs/4D4ABvqNM=";
      "smithay-egui-0.1.0" = "sha256-FcSoKCwYk3okwQURiQlDUcfk9m/Ne6pSblGAzHDaVHg=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ makeBinaryWrapper pkg-config ];
  buildInputs = [
      libglvnd
      libinput
      libxkbcommon
      mesa
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

  # These libraries are only used by the X11 backend, which will not
  # be the common case, so just make them available, don't link them.
  postInstall = ''
    wrapProgramArgs=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
    ]})
  '' + lib.optionalString useXWayland ''
    wrapProgramArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
  '' + ''
    wrapProgram $out/bin/cosmic-comp "''${wrapProgramArgs[@]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    mainProgram = "cosmic-comp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyanbinary ];
    platforms = platforms.linux;
  };
}
