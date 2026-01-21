{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "docker-credential-env";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = "docker-credential-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PnLylYDuDg+FSZ4CUSoQ5gMk4p08FP4OKBxkeIMa+tY=";
  };

  vendorHash = "sha256-uALgz1TXTIk8UlxTaqYOXvCg9121hMIFfJoYC0jxohk=";

  ldflags =
    let
      c = "github.com/docker/docker-credential-helpers/credentials";
    in
    [
      "-s"
      "-X=${c}.Name=docker-credential-env"
      "-X=${c}.Package=github.com/isometry/docker-credential-env"
      "-X=${c}.Version=${finalAttrs.version}"
      "-X=${c}.Revision=${finalAttrs.src.tag}"
    ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/isometry/docker-credential-env/releases/tag/${finalAttrs.src.tag}";
    description = "Environment-driven docker credential helper";
    homepage = "https://github.com/isometry/docker-credential-env";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zowoq ];
    mainProgram = "docker-credential-env";
  };
})
