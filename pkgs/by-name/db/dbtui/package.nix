{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dbtui";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Di3go0-0";
    repo = "dbtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4xIPwR5snakdVVZO9Nc54/Sy4liIYTT2ofUzKlh1lmM=";
  };

  # Upstream gitignores its Cargo.lock, so the release tarball does not contain
  # one. A lock file generated from the v${finalAttrs.version} Cargo.toml is kept
  # next to this file and copied into the source tree before vendoring.
  # See: https://github.com/Di3go0-0/dbtui/blob/v${finalAttrs.version}/.gitignore
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # native-tls, pulled in by sqlx
    openssl
  ];

  meta = {
    description = "Terminal database client with Vim-style navigation";
    longDescription = ''
      A TUI database client with Vim-style navigation, supporting PostgreSQL,
      MySQL, SQL Server and Oracle. It offers a query editor, an explorer for
      the schema, editable result grids, multiple tabs and connections, and
      encrypted storage of saved connections.
    '';
    homepage = "https://github.com/Di3go0-0/dbtui";
    changelog = "https://github.com/Di3go0-0/dbtui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sergioia-dev ];
    mainProgram = "dbtui";
    platforms = lib.platforms.unix;
  };
})
