{
  rustPlatform,
  fetchFromGitHub,
  cacert,
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
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RvxNXlwCF6ER4crGdAHpc7qFLGGyU92pmfgWVLuF/XM=";
  };

  cargoHash = "sha256-wAG8il84ArySdlZnF66YiCP1DK5S1Pl39h1J0AQ48/I=";

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
