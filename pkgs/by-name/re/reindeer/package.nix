{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libgit2,
  libssh2,
  pkg-config,
  openssl,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.10.05.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZaK2T/v7oVwzzQHsHUiM4hEdpmd7g7yRCRqVIwMCL8k=";
  };

  cargoHash = "sha256-C/3mmSDv9g1rrkJxwBIk6Jb5YBxNRXNi6UEgaguOpmc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    sqlite
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # The sandbox's open-file soft limit is above kern.maxfilesperproc, so
    # "raising" it to the capped maximum lowers it
    "--skip=rlimit::tests::raise_does_not_lower_limit"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
