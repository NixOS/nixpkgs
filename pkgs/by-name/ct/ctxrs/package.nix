{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  sqlite,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ctxrs";
  version = "0.25.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ctxrs";
    repo = "ctx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BaZvBlRE8PkUgacWDoNhR14YoenfKKKAoCZQUrv6TQk=";
  };

  cargoHash = "sha256-aOd7zN8U2w/nkoTxUUDrllngtUWZ/3KhGYIAJDa5F5w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    sqlite
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast local search across your past coding agent sessions";
    homepage = "https://github.com/ctxrs/ctx";
    changelog = "https://github.com/ctxrs/ctx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "ctx";
  };
})
