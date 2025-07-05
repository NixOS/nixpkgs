{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dork";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "go-dork";
    tag = "v${version}";
    hash = "sha256-Q7ECwXH9q6qWba2URh3LjMx8g6vPF1DWfKnmXej7ht4=";
  };

  vendorHash = "sha256-6V58RRRPamBMDAf0gg4sQMQkoD5dWauCFtPrwf5EasI=";

  meta = {
    description = "Dork scanner";
    homepage = "https://github.com/dwisiswant0/go-dork";
    changelog = "https://github.com/dwisiswant0/go-dork/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "go-dork";
  };
}
