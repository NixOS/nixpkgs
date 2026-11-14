{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "claudia-statusline";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "hagan";
    repo = "claudia-statusline";
    tag = "v${version}";
    hash = "sha256-A6BYcHsioybpLRfcHW5KeqnpISFZpMIqVWLEk3Fy6Jc=";
  };

  cargoHash = "sha256-NAaTUfqhbXFBAh2GQHAFPXjGTC8MnNnTgN1uDA0lhJs=";

  # Tests fail in sandboxed environment due to filesystem and HOME directory requirements
  doCheck = false;

  meta = {
    description = "Enhanced statusline for Claude Code - track costs, git status, and context usage in real-time";
    homepage = "https://github.com/hagan/claudia-statusline";
    changelog = "https://github.com/hagan/claudia-statusline/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    platforms = lib.platforms.unix;
    mainProgram = "statusline";
  };
}
