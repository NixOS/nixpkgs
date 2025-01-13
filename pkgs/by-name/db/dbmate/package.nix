{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${version}";
    hash = "sha256-Ot8lHwrI848tI8ZGRmw3StLhB5ypTUWZQRCEpW95zGs=";
  };

  vendorHash = "sha256-zu9ilKGWVTNJAOtYIUoHC4yXbBgwmmp2Idv8ZKRZ+b8=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
