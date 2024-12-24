{
  lib,
  stdenv,
  fetchFromGitHub,
  just,
  pkg-config,
  rust,
  rustPlatform,
  libglvnd,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "f07cccbd2dc15ede5aeb7646c61c6f62cb32db0c";
    hash = "sha256-uUq+xElZMcG5SWzha9/8COaenycII5aiXmm7sXGgjXE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1XtW72KPdRM5gHIM3Fw2PZCobBXYDMAqjZ//Ebr51tc=";

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [
    libglvnd
    libxkbcommon
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  # Force linking to libEGL, which is always dlopen()ed.
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    map (a: "-C link-arg=${a}")
      [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-Wl,--pop-state"
      ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    mainProgram = "cosmic-panel";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      qyliss
      nyabinary
    ];
    platforms = platforms.linux;
  };
}
