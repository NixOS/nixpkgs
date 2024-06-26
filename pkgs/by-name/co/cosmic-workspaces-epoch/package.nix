{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  libinput,
  libglvnd,
  mesa,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-workspaces-epoch";
  version = "unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "f61cdc5759235177521fbb6a39f164b9615adfc0";
    hash = "sha256-ZPkPqROZXRLLhv6fbjfsov5hIt+D0K7VFajKebHVZaw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "cosmic-comp-config-0.1.0" = "sha256-NKXIKhZLwZ0BZyGVEplAJ75H5YOsLRNeRrzdhczo3FQ=";
      "cosmic-config-0.1.0" = "sha256-CxeefjDmEqQkXPhWTomF1yb4GCI9vs3OCvMawBGUgaw=";
      "cosmic-protocols-0.1.0" = "sha256-st46wmOncJvu0kj6qaot6LT/ojmW/BwXbbGf8s0mdZ8=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-+gXAFZsS1cWxEisEpP0FMz9q1/UV7L2Ri4ToIP5Bt7s=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    libinput
    libglvnd
    mesa
    udev
    wayland
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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    mainProgram = "cosmic-workspaces";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
