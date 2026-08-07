{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  nasm,
  alsa-lib,
  opus,
  pipewire,
  lib,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DkbZZlURGwQCajhWmkcYmgFZDLvUOg6aU/JjGRiZY4Y=";
  };

  cargoHash = "sha256-ISWQjHUPoYPgMu+aJUDlLjp5AahauHG9BuOAANMXKRA=";

  buildInputs = [
    opus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    pipewire
  ];
  nativeBuildInputs = [
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
