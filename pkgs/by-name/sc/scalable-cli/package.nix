{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  pkg-config,
  aws-lc,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scalable-cli";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ScalableCapital";
    repo = "scalable-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hK+4cBnwFsP3rjVnkR1+SQtCf1hE8a+QeowWKX1m7E4=";
  };

  cargoHash = "sha256-QZKy/W75y6yeBRg0CkYEfx0aawK0xirICiucE1SBt8Y=";

  buildFeatures = [ "channel-prod" ];

  # Tests are written against internal dev-channel configuration and fail
  # when built with the channel-prod feature
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scalable Capital CLI";
    homepage = "https://github.com/ScalableCapital/scalable-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jonasfranke ];
    mainProgram = "sc";
    platforms = lib.platforms.linux;
  };
})
