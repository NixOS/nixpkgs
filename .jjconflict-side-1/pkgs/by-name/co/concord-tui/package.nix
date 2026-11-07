{
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  nasm,
  alsa-lib,
  pipewire,
  libva,
  mesa,
  lib,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.5.17";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W/kpLLz9W9e5f4ja85MeaUGHGpOqiZmRIL4rmBvnT0Y=";
  };

  cargoHash = "sha256-7YdNA6UPVaMT3vC6c91e4vnPN7q1p93ezI0PkNHpIME=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    pipewire
    libva
    mesa
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    rustPlatform.bindgenHook
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ nasm ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/concord" \
      --set-default PIPEWIRE_CONFIG_DIR "${pipewire}/share/pipewire"
  '';

  __darwinAllowLocalNetworking = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich TUI client for Discord, written in Rust";
    homepage = "https://github.com/chojs23/concord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Simon-Weij
      neo
      Br1ght0ne
    ];
    mainProgram = "concord";
  };
})
