{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codesnap";
  version = "0.12.10";

  src = fetchFromGitHub {
    owner = "codesnap-rs";
    repo = "codesnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BIdqSEsQIV5Z2mYMgoW0gtBaMNxhEsAbZbs/KDJEK4E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-xenMTuCy3ABEBddH759m0AgMJUlsS0eFj473Y6qjzkY=";

  cargoBuildFlags = [
    "-p"
    "codesnap-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for generating beautiful code snippets";
    homepage = "https://github.com/mistricky/CodeSnap";
    changelog = "https://github.com/mistricky/CodeSnap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "codesnap";
  };
})
