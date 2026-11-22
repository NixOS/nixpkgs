{
  lib,
  stdenv,
  aws-lc,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = "feroxbuster";
    tag = "v${version}";
    hash = "sha256-sDEp7Qz10FA7iGtgiDKEIljiYjGUvvI7mcCZfB2mfzw=";
  };

  cargoHash = "sha256-shR6GMpSpSGSVUIXdMWEFfBMFwPSAvJ+4O7kBcmg0KQ=";

  env.OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    aws-lc
    openssl
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.unix;
    mainProgram = "feroxbuster";
  };
}
