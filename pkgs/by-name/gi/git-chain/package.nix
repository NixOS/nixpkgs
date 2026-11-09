{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libz,
  openssl,
  git,
  nix-update-script,
  stdenv, # for meta.broken
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-chain";
  version = "0.0.15";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "git-chain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wqS5Htwh1zeD9bqMc3+T7WBKAPRjNXJsgnZ95Ah0a/0=";
  };

  cargoHash = "sha256-QWXBf7MoibwIsBWzkDwXDMfLjZHlBlfn3BZPzfdi5u0=";

  env = {
    LIBZ_SYS_STATIC = 0;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libz
    openssl
  ];

  nativeCheckInputs = [ git ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for rebasing a chain of local git branches";
    homepage = "https://github.com/dashed/git-chain";
    changelog = "https://github.com/dashed/git-chain/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-chain";
    maintainers = with lib.maintainers; [ bcyran ];
  };
})
