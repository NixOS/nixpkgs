{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "hydra";
  version = "26.2.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LnF1k/C9uPRY4xXeBCJPSQ8gxwwZx0N1e1s+Rhop5ic=";
  };

  vendorHash = "sha256-KVCoDATyt5Qp0r3vGwdXqkjh0FEdNyKi6mXk99D6HD8=";

  # `json1` not needed (see: https://github.com/ory/hydra/commit/93edc9ad894771c67f46ae2c57ee7e50382d73cd)
  # `sqlite_omit_load_extension` consistency with upstream (see: https://github.com/ory/hydra/blob/master/.docker/Dockerfile-local-build#L20C58-L20C84). Will disable sqlite runtime extension loading (see: https://sqlite.org/loadext.html)
  tags = [
    "hsm"
    "sqlite"
    "sqlite_omit_load_extension"
  ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/ory/hydra/v2/driver/config.Version=v${finalAttrs.version}"
    "-X github.com/ory/hydra/v2/driver/config.Commit=${finalAttrs.src.rev}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "OpenID Certified™ OAuth 2.0 Server and OpenID Connect Provider";
    homepage = "https://www.ory.com/hydra";
    changelog = "https://github.com/ory/hydra/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      debtquity
    ];
    mainProgram = "hydra";
  };
})
