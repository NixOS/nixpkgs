{ lib, rustPlatform, fetchFromGitHub, makeBinaryWrapper, pkg-config
, libinput, libglvnd, libxkbcommon, mesa, seatd, udev, wayland, xorg
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "unstable-2023-10-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "a3ac6c42b6913193b76e481d9a60f775f67aa858";
    hash = "sha256-nPQx3Pkd9WAq9ooLs8K8UI1rCHYwJlu88SP2PbC/avU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "calloop-0.12.2" = "sha256-d/LB65l1DEC/5Kk8yvenTQYfIFBs99XqXn4tAM2mfHI=";
      "cosmic-config-0.1.0" = "sha256-0HKv0/UHZMpSGF54aCip9PbwfWiWMSMHZpiipM6Qrf0=";
      "cosmic-protocols-0.1.0" = "sha256-oBE/69A4haCN6Etih6B8SlbSnKg1bEocI6Rvf9IegLE=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-7oOVAoEl+X09e0+V1eR5GviodntMbineEO8Igk2+BM0=";
      "smithay-egui-0.1.0" = "sha256-FcSoKCwYk3okwQURiQlDUcfk9m/Ne6pSblGAzHDaVHg=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
      "taffy-0.3.11" = "sha256-Py9D8+L9G+sBkHPtlenOdugH5nQKTXa+XdKArOg5+qU=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ makeBinaryWrapper pkg-config ];
  buildInputs = [ libglvnd libinput libxkbcommon mesa seatd udev wayland ];

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
    wrapProgram $out/bin/cosmic-comp \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
      ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
