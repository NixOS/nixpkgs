{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sbom-utility";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "sbom-utility";
    rev = "refs/tags/v${version}";
    hash = "sha256-LiHCA5q9IJ67jZ2JUcbCFVCYnT36nyq9QzgH9PMr9kM=";
  };

  vendorHash = "sha256-vyYSir5u6d5nv+2ScrHpasQGER4VFSoLb1FDUDIrtDM=";

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
