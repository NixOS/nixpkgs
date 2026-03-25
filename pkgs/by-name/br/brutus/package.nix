{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "brutus";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "brutus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xpgBXszLk3BXEZ3sUFYn4IpuVLCuMUpMS7XasnrAXw4=";
  };

  vendorHash = "sha256-1hP4gitbpm3wFhLu7OJ3gQMVkZKZJEZAKvhfejSOYMI=";

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
