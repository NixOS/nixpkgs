{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "h2spec";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "summerwind";
    repo = "h2spec";
    tag = "v${version}";
    hash = "sha256-HEvaE363bqwE9o0FPue+x+SaThohmCWbFXSraB0hP1I=";
  };

  vendorHash = "sha256-LR5YN0M8PQjQMMsbhQvITFXuhNG8J/poijYeeh2fHYs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
    "-X main.COMMIT=${version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Testing tool for HTTP/2 implementation";
    homepage = "https://github.com/summerwind/h2spec";
    changelog = "https://github.com/summerwind/h2spec/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "h2spec";
  };
}
