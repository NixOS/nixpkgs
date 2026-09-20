{
  lib,
  fetchFromGitHub,
  nix-update-script,
  oniguruma,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  writableTmpDirAsHomeHook,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ciphey";
  version = "0.12.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "Ciphey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jaI++uyAHXbx/o0qqbrDtVQbYjffecfKXAb4NCSXIRU=";
  };

  cargoHash = "sha256-Kn2lHsw4SGV8kE6AxjryL+To9OMq5loUE7GCndVbyWI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
    openssl
    sqlite
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to automatically decrypt encryptions or hashes";
    homepage = "https://github.com/bee-san/Ciphey";
    changelog = "https://github.com/bee-san/Ciphey/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ciphey";
  };
})
