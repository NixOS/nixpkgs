{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "harsh";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MpKfUvDqwkvPsnjTxR3fohzYfSLQ2Nx25czYOE8LpK4=";
  };

  vendorHash = "sha256-zjLXq64uC5iRm9uxUGDW5127z25gNSVV2qhVVXuYqY0=";

  meta = with lib; {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ laurailway ];
  };
}
