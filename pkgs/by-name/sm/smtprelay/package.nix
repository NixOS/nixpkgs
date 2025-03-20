{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "smtprelay";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${version}";
    hash = "sha256-SwLRodyg6DC9gssmwbdKk426V71bKt3yhj9nqn0X3nU=";
  };

  vendorHash = "sha256-poTToZlC/yNM4tD9PCVUGTMFEtbA7N8xgK/fmJfUMnE=";

  subPackages = [
    "."
  ];

  env.CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ juliusrickert ];
  };
}
