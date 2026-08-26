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
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "codesnap-rs";
    repo = "codesnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cMxXzLvnqsloKT7ixMlQnAq+ZempLeEzkWyWxG4jt9Y=";
  };

  cargoHash = "sha256-QMpncisumxF02lFQ8xsZiR5AYZVSHWlAuuFDg0ZoPtI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "-p"
    "codesnap-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
