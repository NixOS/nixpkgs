{
  lib,
  stdenv,
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

  # cargo-nextest is only used as the upstream test runner. It is not needed
  # by the test suite itself, and its nextest-runner dependency pulls in usdt,
  # which fails to build on Darwin.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Cargo.toml \
      --replace-fail 'cargo-nextest = "0.9.117"' ""
  '';

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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool to automatically decrypt encryptions or hashes";
    homepage = "https://github.com/bee-san/Ciphey";
    changelog = "https://github.com/bee-san/Ciphey/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ciphey";
  };
})
