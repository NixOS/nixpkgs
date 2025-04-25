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
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-QcrkfU6HNZ2tWfKsMdcv58HC/PE7b4T14AIep85TWOY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qufOJeWPRjj4GgWNJmQfYaGKeYOQbkTeFzrUSi9QNnQ=";

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
