{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "helix-db";
  version = "2.1.3";

  src = fetchFromGitHub {
    repo = "helix-db";
    owner = "HelixDB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oy17xutabfTmdkyi3Ak61f4fhd65m+Cwk+1a156K2hQ=";
  };

  cargoHash = "sha256-KrrbQwxhqtO8ISq7WWSo67t58dOuI3gS/9nesVCIq+0=";

  patches = [
    #There are no feature yet
    ./disable-updates.patch
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  cargoBuildFlags = [
    "-p"
    "helix-cli"
  ];

  #There are no tests
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source graph-vector database built from scratch in Rust";
    homepage = "https://github.com/HelixDB/helix-db";
    changelog = "https://github.com/HelixDB/helix-db/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "helix";
  };
})
