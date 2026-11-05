{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  sops,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sops-sakura-kms";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "sops-sakura-kms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81i8VsZOlEd77b0VZ7B1EoSjzArw7Gp4v3yQQeXNwd0=";
  };

  subPackages = [
    "cmd/sops-sakura-kms"
  ];

  vendorHash = "sha256-tK3P2q+3vxV+XEda/HQFz8fs6J0OfVW4ik/nGgsWnlE=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/sops-sakura-kms \
      --prefix PATH : ${lib.makeBinPath [ sops ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOPS wrapper that uses Sakura Cloud KMS";
    homepage = "https://github.com/fujiwara/sops-sakura-kms";
    changelog = "https://github.com/fujiwara/sops-sakura-kms/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a2not ];
    mainProgram = "sops-sakura-kms";
  };
})
