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
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "encrypted-dns-server";
    tag = finalAttrs.version;
    hash = "sha256-YM9ow1j5G6AN91/YLnRy+jOlpQPBxZa+chNZNPGUfhs=";
  };

  cargoHash = "sha256-cHARkL8gbNBlmjbJaHJ8w268KcXTJr2PvCF+I6+K0s8=";

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
