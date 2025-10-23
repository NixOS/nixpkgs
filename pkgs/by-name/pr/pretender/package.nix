{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pretender";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "pretender";
    tag = "v${version}";
    hash = "sha256-c8uXN7UMj6UZPVt2aNSg6mRex8w+u7J5I7TAB7MzEWg=";
  };

  vendorHash = "sha256-UzKprzkxqG7FOPWcFQGuZtn+gHMeMy4jqCLUSdyO2l0=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for handling machine-in-the-middle tasks";
    mainProgram = "pretender";
    homepage = "https://github.com/RedTeamPentesting/pretender";
    changelog = "https://github.com/RedTeamPentesting/pretender/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
