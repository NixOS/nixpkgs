{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matcha-rss-digest";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "matcha";
    rev = "v${version}";
    hash = "sha256-Zk85k2SllPR9zznLGevwH6hS1EEW2qEa9YXbSguRVeM=";
  };

  vendorHash = "sha256-Dw1z23DRG0OtakJfrgpTfd71F58KfGsqz215zK0XOdI=";

  meta = with lib; {
    homepage = "https://github.com/piqoni/matcha";
    description = "Daily digest generator from a list of RSS feeds";
    license = licenses.mit;
    mainProgram = "matcha";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
