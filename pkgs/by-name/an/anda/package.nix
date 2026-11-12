{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anda";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "FyraLabs";
    repo = "anda";
    tag = finalAttrs.version;
    hash = "sha256-bha3bZcweA6ciUtazKsYkXXiG5LOagqJ2no9xYWK+A4=";
  };

  cargoHash = "sha256-oha0Tlv968N8qDv/kSxO2N+SKXgCInvI4kMrCaprBFw=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A modern Build/CI System";
    homepage = "https://github.com/FyraLabs/anda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "anda";
  };
})
