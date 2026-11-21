{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "pindock";
  version = "1.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deadnews";
    repo = "pindock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-abjBvOubNBCrfR3J5JyIsH5qEaURhDfz+ckrESL+DfE=";
  };

  vendorHash = "sha256-HybznkCWimCsx2vupaerph4Uvbi+ybYOhuw+Q9Xq27E=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pin and update Docker image digests in Dockerfiles and compose files";
    homepage = "https://github.com/deadnews/pindock";
    changelog = "https://github.com/deadnews/pindock/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pindock";
  };
})
