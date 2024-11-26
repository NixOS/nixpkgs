{
  lib,
  # Required based on 'go' directive in go.mod,
  # remove when Go in nixpkgs defaults to 1.23 or later.
  buildGo123Module,
  fetchFromGitHub,
}:

buildGo123Module rec {
  pname = "agebox";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RtFa7k+tw0hyf7bYm51aIxptaD4uOH6/3WDjeoWEEKA=";
  };

  vendorHash = "sha256-57YbYDvRYOzQATEFpAuGzQzOYNY8n5LUrcu8jhjSiNI=";

  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
    mainProgram = "agebox";
  };
}
