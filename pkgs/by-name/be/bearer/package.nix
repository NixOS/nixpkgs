{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bearer";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-whLT9fCJFd0MlFJZi9MR/azxbcqBI7eFVIkktlIBdnE=";
  };

  vendorHash = "sha256-T1tJGq1TRDIr6ZF1uYKitm5ZCqxTSfQpVpXFriB5JeE=";

  subPackages = [ "cmd/bearer" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/bearer/bearer/cmd/bearer/build.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Code security scanning tool (SAST) to discover, filter and prioritize security and privacy risks";
    homepage = "https://github.com/bearer/bearer";
    changelog = "https://github.com/Bearer/bearer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bearer";
  };
})
