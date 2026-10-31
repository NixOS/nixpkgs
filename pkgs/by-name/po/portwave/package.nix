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
  version = "0.19.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "assassin-marcos";
    repo = "portwave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0AAVAMqBtvuN2ElBbEVaJaIL5nfVXEcJOPnmJM9JJFk=";
  };

  cargoHash = "sha256-QPaL5ifmxwpUuHgEYowrdguGtK56UYW0K0bbIf3POEY=";

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
