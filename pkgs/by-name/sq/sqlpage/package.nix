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

  preBuild = ''
    npm run build
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
