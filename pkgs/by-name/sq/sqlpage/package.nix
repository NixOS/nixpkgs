{
  aws-lc,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nix-update-script,
  nodejs,
  npmHooks,
  pkg-config,
  rustPlatform,
  sqlite,
  unixodbc,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqlpage";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "sqlpage";
    repo = "SQLpage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RK0k0lhXagGR79FFgsH2+p58ydaMYD2yhpEKIFZQ00A=";
  };

  cargoHash = "sha256-+RMLsR7fR7K1YZSVN3VmLQUt8RLrFczRt574yvuFQcs=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-bp8+lP7cUAWf/4EieiwEryFbIBmO0AxXJvHfABruj6g=";
  };

  # sqlx opens its shared in-memory database as "file:sqlx-in-memory-N" without
  # SQLITE_OPEN_URI. The bundled SQLite is built with SQLITE_USE_URI and parses
  # the URI anyway; the system SQLite doesn't, so every pooled connection gets
  # its own empty database.
  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/sqlx-core-oldapi-*/src/sqlite/connection/establish.rs \
      --replace-fail 'flags |= SQLITE_OPEN_MEMORY;' 'flags |= SQLITE_OPEN_MEMORY | libsqlite3_sys::SQLITE_OPEN_URI;'
  '';

  preBuild = ''
    npm run build
  '';

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    aws-lc
    sqlite
    unixodbc
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # Tests bind to and connect to localhost
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    downloadPage = "https://github.com/sqlpage/SQLpage";
    homepage = "https://sql-page.com";
    changelog = "https://github.com/sqlpage/SQLpage/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      _81reap
      hythera
    ];
    mainProgram = "sqlpage";
  };
})
