{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "epi052";
    repo = "feroxbuster";
    tag = "v${version}";
    hash = "sha256-uVRZp9r3888k//UsNUr7NKQcmFe2/RLmlIt/RgZ3Ips=";
  };

  cargoHash = "sha256-W6sNc8RVItOGHIw3vmtZlJayqrzvmuET2B2AIl7LAL4=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  buildInputs = [ openssl ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/v${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
    mainProgram = "feroxbuster";
  };
}
