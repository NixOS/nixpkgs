{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  aws-lc,
  openssl,
  pkg-config,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chess-tui";
  version = "2.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    tag = finalAttrs.version;
    hash = "sha256-/D6eujVIxjEakmpj9IKfNFUxQ3p0ZBC27o9gQaj7h1M=";
  };

  cargoHash = "sha256-2iPeVskEaW1G7m1OAHc0ow3qPyjvI7s9JGc9gBibmDA=";

  checkFlags = [
    # assertion failed: result.is_ok()
    "--skip=tests::test_config_create"
  ];

  buildInputs = [
    aws-lc
    openssl
  ]
  # alsa-lib is required for the alsa-sys. alsa-lib does not compile on darwin
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
  # bindgenHook is required for coreaudio-sys on darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    changelog = "https://github.com/thomas-mauran/chess-tui/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [
      ByteSudoer
      kybe236
    ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "chess-tui";
  };
})
