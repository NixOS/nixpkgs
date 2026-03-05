{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule (finalAttrs: {
  pname = "aws-signing-helper";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ouAIip9IsAixeQ1fjf3zrquiXhL38bX6CkbzGnf5vSo=";
  };
  vendorHash = "sha256-2NYMp61UB4zFLaX5qUm3v3kqKcWD8MQrzaOpcxuRSiE=";

  checkPhase = ''
    runHook preCheck
    export SHELL=${bash}/bin/bash
    go test ./cmd/...
    runHook postCheck
  '';

  postInstall = ''
    mv $out/bin/rolesanywhere-credential-helper $out/bin/aws_signing_helper
  '';

  meta = {
    description = "AWS Signing Helper for IAM Roles Anywhere";
    homepage = "https://github.com/aws/rolesanywhere-credential-helper";
    changelog = "https://github.com/aws/rolesanywhere-credential-helper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "aws_signing_helper";
    maintainers = with lib.maintainers; [ pandanz ];
  };
})
