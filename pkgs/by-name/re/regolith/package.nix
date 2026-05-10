{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "regolith";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Bedrock-OSS";
    repo = "regolith";
    tag = finalAttrs.version;
    hash = "sha256-9mRfK93eHuCA19RSdLKhlhbnQ0UTmBS46Gp1cXstTIk=";
  };

  # Requires network access.
  doCheck = false;

  vendorHash = "sha256-jQeIPJJyANS+U9NrjLSnXHAecCK4rHPZrP5JFsMwcm8=";

  ldflags = [
    "-X main.buildSource=nix"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add-on Compiler for the Bedrock Edition of Minecraft";
    homepage = "https://github.com/Bedrock-OSS/regolith";
    changelog = "https://github.com/Bedrock-OSS/regolith/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arexon ];
    mainProgram = "regolith";
  };
})
