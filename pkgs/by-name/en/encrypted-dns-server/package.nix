{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "encrypted-dns-server";
  version = "0.9.20";

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "encrypted-dns-server";
    tag = finalAttrs.version;
    hash = "sha256-tyNyIgfOVTSuDiBUILdcNsHt0aRcn7cxiS0CND6FUS4=";
  };

  cargoHash = "sha256-u8u6doAf8PjkaVqZN2JCdp6wXjilGGzlloePH0DNrt4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsodium ];

  env = {
    SODIUM_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/encrypted-dns";

  meta = {
    changelog = "https://github.com/DNSCrypt/encrypted-dns-server/releases/tag/${finalAttrs.version}";
    description = "Easy to install, high-performance, zero maintenance proxy to run an encrypted DNS server";
    homepage = "https://github.com/DNSCrypt/encrypted-dns-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "encrypted-dns";
  };
})
