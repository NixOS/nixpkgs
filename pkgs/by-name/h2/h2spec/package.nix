{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "h2spec";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "summerwind";
    repo = "h2spec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HEvaE363bqwE9o0FPue+x+SaThohmCWbFXSraB0hP1I=";
  };

  vendorHash = "sha256-LR5YN0M8PQjQMMsbhQvITFXuhNG8J/poijYeeh2fHYs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${finalAttrs.version}"
    "-X main.COMMIT=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Testing tool for HTTP/2 implementation";
    homepage = "https://github.com/summerwind/h2spec";
    changelog = "https://github.com/summerwind/h2spec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "h2spec";
  };
})
