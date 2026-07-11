{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "brutus";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "brutus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iZ0oUYlrcPxPGuJvHXqHX+R4dXKS7pLgZgNhBuBVWtc=";
  };

  vendorHash = "sha256-XpwwFz8PfyTksLD0SomC5BE0tzUL9D/qtBSed4mrsXQ=";

  ldflags = [
    "-s"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.BuildTime=1970-01-01T00:00:00Z"
    "-X=main.CommitSHA=${finalAttrs.src.rev}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Credential testing tool for multiple services";
    homepage = "https://github.com/praetorian-inc/brutus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "brutus";
  };
})
