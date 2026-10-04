{
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
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
  version = "0.46.3-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "sqlpage";
    repo = "SQLpage";
    rev = "6199e6f5e32a6fc152cec9be167427e64f24e65a";
    hash = "sha256-thyIMtG99h3WvU3V7ZtI7xmua6nqvyoBRFXrgBUenf0=";
  };

  cargoHash = "sha256-Ga6hr1YeFCrBsGq64z7yYHQP07boV7BsHqHxL5YSjfo=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-bp8+lP7cUAWf/4EieiwEryFbIBmO0AxXJvHfABruj6g=";
  };

  preBuild = ''
    node scripts/build-frontend.mjs
  '';

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    sqlite
    unixodbc
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    downloadPage = "https://github.com/sqlpage/SQLpage";
    homepage = "https://sql-page.com";
    changelog = "https://github.com/sqlpage/SQLpage/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "sqlpage";
  };
})
