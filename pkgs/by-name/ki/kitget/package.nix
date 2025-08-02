{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kitget";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "adamperkowski";
    repo = "kitget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i26nu5SkcPhqwh+/bw1rz7h8K2u+hhSsOGiLj3sF1RQ=";
  };

  # the project does not implement rust unit testing
  doCheck = false;
  cargoHash = "sha256-RT2sl5p3d4FixtkpuUDLeMmFLN7kceoR3GCD5DW91mY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/adamperkowski/kitget";
    changelog = "https://github.com/adamperkowski/kitget/releases/tag/v${finalAttrs.version}";
    description = "Display and customize cat images in your terminal";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sebaguardian ];
    mainProgram = "kitget";
  };
})
