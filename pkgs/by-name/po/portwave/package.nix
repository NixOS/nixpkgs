{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portwave";
  version = "0.19.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "assassin-marcos";
    repo = "portwave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N1/ryYMwlkwPfOZexZVFiR2Wr8w8zq6l9gKK4PLPJqU=";
  };

  cargoHash = "sha256-5UOsPswU+nyH5x3JDcyPgUbhIPxRzWzWyekwZboKdlE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IPv4/IPv6 port scanner with adaptive concurrency";
    homepage = "https://github.com/assassin-marcos/portwave";
    changelog = "https://github.com/assassin-marcos/portwave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "portwave";
  };
})
