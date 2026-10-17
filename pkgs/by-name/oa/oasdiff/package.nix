{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "oasdiff";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "oasdiff";
    repo = "oasdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tCRk5lgZFTpGlI6w0gniaorRnJMYi/g7wcYBcMIfks0=";
  };

  vendorHash = "sha256-OEZgmxEQ8OKVkfk0009+2HdoKXyImI/1VnLi6P0EkEQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/oasdiff/oasdiff/build.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Compare OpenAPI specs and detect breaking changes";
    homepage = "https://www.oasdiff.com";
    changelog = "https://github.com/oasdiff/oasdiff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zlatkoc ];
    mainProgram = "oasdiff";
  };
})
