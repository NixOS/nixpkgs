{
  lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sbom-utility";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "sbom-utility";
    rev = "refs/tags/v${version}";
    hash = "sha256-EqK2TGlv2RGfvR95lzYz3EHJkfq4q4Ty5H2zFdd9cME=";
  };

  vendorHash = "sha256-qh8kIwgrlmHkocM5ZoGnOY7ISJlct/TV7dAxvXlPw68=";

  preCheck = ''
    cd test
  '';

  meta = with lib; {
    description = "Utility that provides an API platform for validating, querying and managing BOM data";
    homepage = "https://github.com/CycloneDX/sbom-utility";
    changelog = "https://github.com/CycloneDX/sbom-utility/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ thillux ];
    mainProgram = "sbom-utility";
  };
}
