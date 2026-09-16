{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pkg-config,
  just,
  libxkbcommon,
  wayland,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "0-unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "d8840236acbaf3679acd7c4b10102b86e7da27f6";
    hash = "sha256-GTSz0NRRImdweLx0PdgrwJ/iL5ujeyysbxAuHlX5AUQ=";
  };

  cargoHash = "sha256-0CziruLYJrku1FO7tBSJRNtS5JyhjDWxTEcOwUVYmSk=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
    just
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  postPatch = ''
    substituteInPlace justfile \
      --replace-warn '`git rev-parse --short HEAD`' '"${version}"'
  '';

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = with lib; {
    description = "Clipboard manager applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    license = licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-clipboard-manager";
    maintainers = with maintainers; [ krit ];
    platforms = platforms.linux;
  };
}
