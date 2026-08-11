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
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m74ar1ue0Cl7G5QYeuzyzcgt4myQQUIULwLLol23lBA=";
  };

  cargoHash = "sha256-uLx+djlScpkvSuAlh9O3rqCDZg11eCVrwh46HppfUpE=";

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
