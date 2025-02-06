{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pretender";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-msxGCQkF5u5sIjvy4GCRBIivzoiIDsOjesIf3d8goVI=";
  };

  vendorHash = "sha256-UzKprzkxqG7FOPWcFQGuZtn+gHMeMy4jqCLUSdyO2l0=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for handling machine-in-the-middle tasks";
    mainProgram = "pretender";
    homepage = "https://github.com/RedTeamPentesting/pretender";
    changelog = "https://github.com/RedTeamPentesting/pretender/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
