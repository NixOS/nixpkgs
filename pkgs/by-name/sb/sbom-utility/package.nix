{
  lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sbom-utility";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "sbom-utility";
    rev = "refs/tags/v${version}";
    hash = "sha256-tNLMrtJj1eeJ4sVhDRR24/KVI1HzZSRquiImuDTNZFI=";
  };

  vendorHash = "sha256-EdzI5ypwZRksQVmcfGDUgEMa4CeAPcm237ZaKqmWQDY=";

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
