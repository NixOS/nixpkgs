{
  lib,
  cedar,
  testers,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cedar";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${version}";
    hash = "sha256-p8idQx3HGO/ikL0pDTPXx5+rD2sRpXANqs/g51BL554=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-puVPSPPpKAlawN4OXrehIdqlJ6gmZxP/tiFzn1V/o4A=";

  passthru = {
    tests.version = testers.testVersion { package = cedar; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Implementation of the Cedar Policy Language";
    homepage = "https://github.com/cedar-policy/cedar";
    changelog = "https://github.com/cedar-policy/cedar/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "cedar";
  };
}
