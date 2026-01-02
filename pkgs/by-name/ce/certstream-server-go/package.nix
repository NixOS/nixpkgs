{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "certstream-server-go";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "d-Rickyy-b";
    repo = "certstream-server-go";
    tag = "v${version}";
    hash = "sha256-06CoeGPOsJItqUuXbBo2Wxhn2KwqbjpCA8GE1Ng7978=";
  };

  vendorHash = "sha256-+7wL6JA5sNRNJQKelVkEVCZ5pqOlmn8o7Um2g6rsIlc=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Drop-in replacement in Golang for the certstream server by Calidog";
    homepage = "https://github.com/d-Rickyy-b/certstream-server-go";
    changelog = "https://github.com/d-Rickyy-b/certstream-server-go/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "certstream-server-go";
  };
}
