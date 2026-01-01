{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "encrypted-dns-server";
<<<<<<< HEAD
  version = "0.9.18";
=======
  version = "0.9.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "encrypted-dns-server";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-YM9ow1j5G6AN91/YLnRy+jOlpQPBxZa+chNZNPGUfhs=";
  };

  cargoHash = "sha256-cHARkL8gbNBlmjbJaHJ8w268KcXTJr2PvCF+I6+K0s8=";
=======
    hash = "sha256-un7607HQ7s7G2GPTmYVT3wK/ePLNVyV+A2mtKt0YGsw=";
  };

  cargoHash = "sha256-qhY1LgtV0Kmj/at9EG7Y+swN1Oy0/SzRCr7U8xVh8KA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsodium ];

  env = {
    SODIUM_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/encrypted-dns";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/DNSCrypt/encrypted-dns-server/releases/tag/${version}";
    description = "Easy to install, high-performance, zero maintenance proxy to run an encrypted DNS server";
    homepage = "https://github.com/DNSCrypt/encrypted-dns-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "encrypted-dns";
  };
}
