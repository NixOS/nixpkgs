{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "regolith";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Bedrock-OSS";
    repo = "regolith";
    tag = version;
    hash = "sha256-gTEQ2hu581tD1I/3iLHzE/2nekAG49/M6V6QeqPhYsA=";
  };

  # Requires network access.
  doCheck = false;

  vendorHash = "sha256-+4J4Z7lhbAphi6WUEJN9pzNXf6ROUKqN4NdKI2sQSW0=";

  ldflags = [
    "-X main.buildSource=nix"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add-on Compiler for the Bedrock Edition of Minecraft";
    homepage = "https://github.com/Bedrock-OSS/regolith";
    changelog = "https://github.com/Bedrock-OSS/regolith/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arexon ];
    mainProgram = "regolith";
  };
}
