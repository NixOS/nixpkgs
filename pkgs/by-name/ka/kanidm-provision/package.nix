{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "kanidm-provision";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    rev = "v${version}";
    hash = "sha256-pFOFFKh3la/sZGXj+pAM8x4SMeffvvbOvTjPeHS1XPU=";
  };

  cargoHash = "sha256-oiKlKIL23xH67tCDbny9Gj97JQQm4mYt0IHXB5hzJ/A=";

  meta = with lib; {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [oddlama];
    mainProgram = "kanidm-provision";
  };
}
