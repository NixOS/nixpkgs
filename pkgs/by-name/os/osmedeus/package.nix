{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "osmedeus";
  version = "5.0.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "osmedeus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KsYbPOPP2LCOmZOGZLzuDJtg3UR0Kn9Lkyp1KbsoOjg=";
  };

  vendorHash = "sha256-sIf54V4jhTOztpTc1y5emMsOB7TNzCvQxByF+iNQF2g=";

  subPackages = [ "cmd/osmedeus" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.CommitHash=${finalAttrs.src.rev}"
  ];

  # Requires additional setup
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Orchestration Engine for Security";
    longDescription = ''
      Osmedeus is a security focused declarative orchestration engine that simplifies complex workflow automation into auditable YAML definitions, complete with encrypted data handling, secure credential management, and sandboxed execution.
    '';
    homepage = "https://github.com/j3ssie/osmedeus";
    changelog = "https://github.com/j3ssie/osmedeus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katok ];
    mainProgram = "osmedeus";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
