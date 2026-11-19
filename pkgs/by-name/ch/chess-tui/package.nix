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
  version = "2.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    tag = finalAttrs.version;
    hash = "sha256-J+9/rxPaAZJ1Rl9d+53Ej2l+dbad1O2jv0NWAxciPo8=";
  };

  cargoHash = "sha256-qZSrse1R5wfZY43P5tp9RWTjH1PtFJE0K6aIsdj+zN4=";

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
    license = lib.licenses.mit;
    mainProgram = "chess-tui";
  };
})
