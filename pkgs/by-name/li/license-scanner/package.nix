{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "license-scanner";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "license-scanner";
    tag = "v${version}";
    hash = "sha256-XnJ0GrME8v3d/sYwOffGX6S0u9toJxmFf9XCqA7jxZ4=";
  };

  vendorHash = "sha256-JVbwGTYNTFana9jE42h6nhDyyoVlROcK7RLRC7S74eA=";

  meta = {
    description = "Utility that provides an API and CLI to identify licenses and legal terms";
    homepage = "https://github.com/CycloneDX/license-scanner";
    changelog = "https://github.com/CycloneDX/license-scanner/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "license-scanner";
  };
}
