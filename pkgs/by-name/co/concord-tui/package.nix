{
  rustPlatform,
  fetchFromGitHub,
  cacert,
  cmake,
  git,
  pkg-config,
  makeWrapper,
  nasm,
  alsa-lib,
  pipewire,
  libva,
  mesa,
  zstd,
  lib,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ck5BE1U5vajr0nE2KDeTfWZg1xBDbs0yCnpMZTIt/pU=";
  };

  cargoHash = "sha256-rupp7IH/90/QHwK4gmYPQDdlsNOwXGYiwL7ODEdUZDE=";

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    pipewire
    libva
    mesa
  ];
  nativeBuildInputs = [
    cmake
    git
    pkg-config
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ nasm ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ cacert ];

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
      inomish
      neo
      Br1ght0ne
    ];
    mainProgram = "concord";
  };
})
