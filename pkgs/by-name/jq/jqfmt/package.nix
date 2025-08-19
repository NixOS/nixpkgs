{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule {
  pname = "jqfmt";
  version = "0-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "noperator";
    repo = "jqfmt";
    rev = "74b59e03caff3ac5a8c061088d2c228a5c27b171";
    hash = "sha256-3PYIyjZm265atBAfuj5aHmWoAv4H29I7gN4/rjl1d0o=";
  };

  vendorHash = "sha256-avpZSgQKFZxLmYGj+2Gi+wSDHnAgF0/hyp4HtoQ0ZCo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Like gofmt, but for jq";
    homepage = "https://github.com/noperator/jqfmt";
    license = lib.licenses.mit; # Doesn't have Licence file, but Readme points to MIT
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "jqfmt";
  };
}
