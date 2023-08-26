{ lib, stdenv, rust, rustPlatform, fetchFromGitHub, makeBinaryWrapper, pkg-config
, libinput, libglvnd, libxkbcommon, mesa, seatd, udev, wayland, xorg
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "1f3761a5daeb4ba64c586713ca35725fabdbba2e";
    hash = "sha256-TrOb0g3gnN8+8cU4L4zuGjKW7qct0VDD80fLS9xvWJQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-config-0.1.0" = "sha256-uG3/l+DuTGgC190NP2WL+a0Yrtl8bLbZignQv6QuSYc=";
      "cosmic-protocols-0.1.0" = "sha256-pVWK+dODQxNej5jWyb5wX/insoiXkX8NFBDkDEejVV0=";
      "cosmic-text-0.8.0" = "sha256-3uf+mjBsjvdl5JLC7ieY4w3WYJeoXRCnu8cMA+jvXxY=";
      "directories-4.0.1" = "sha256-4M8WstNq5I7UduIUZI9q1R9oazp7MDBRBRBHZv6iGWI=";
      "glyphon-0.2.0" = "sha256-h72qWF99l1hnp+vz6fEjX/dLQFTLf53e/tZmtKAV8KI=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-/d8YV4vcY8slFn+bG19CKvPESdMMqil+jH1I38sl4Sk=";
      "smithay-egui-0.1.0" = "sha256-H1Bsv8iO12wXJbzMlEU3eP7BroLK8uL8t5UYbLiY8d4=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ makeBinaryWrapper pkg-config ];
  buildInputs = [ libglvnd libinput libxkbcommon mesa seatd udev wayland ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  "CARGO_TARGET_${rust.lib.toRustTargetForUseInEnvVars stdenv.hostPlatform}_RUSTFLAGS" = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  # These libraries are only used by the X11 backend, which will not
  # be the common case, so just make them available, don't link them.
  postInstall = ''
    wrapProgram $out/bin/cosmic-comp \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
      ]}
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
