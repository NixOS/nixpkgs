{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    tag = "v${version}";
    hash = "sha256-fxlarxb0HAUPDFI0dtnRTKkLoRS/dfs6ZaNPU0UKS4Y=";
  };

  vendorHash = "sha256-a7EUZXCth2lj172xwyNldoEKHnZrncX4RetAUNAZsrg=";

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
