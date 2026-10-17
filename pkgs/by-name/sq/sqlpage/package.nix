{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  pkg-config,
  sqlite,
  unixodbc,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sqlpage";
  version = "0.46.3-unstable-2026-10-14";

  src = fetchFromGitHub {
    owner = "sqlpage";
    repo = "SQLpage";
    rev = "362ce5977f87bf4d275920a5f069b3b496ee3f28";
    hash = "sha256-7SV1/FKS82xko3DpjVdzKiBtw9hLlyPk96nylV9NaNw=";
  };

  cargoHash = "sha256-Ga6hr1YeFCrBsGq64z7yYHQP07boV7BsHqHxL5YSjfo=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    inherit (finalAttrs) src;
    hash = "sha256-bp8+lP7cUAWf/4EieiwEryFbIBmO0AxXJvHfABruj6g=";
  };

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

  preBuild = ''
    npm run build
  '';

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    homepage = "https://sql-page.com";
    downloadPage = "https://github.com/sqlpage/SQLpage";
    changelog = "https://github.com/sqlpage/SQLpage/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "sqlpage";
  };
})
