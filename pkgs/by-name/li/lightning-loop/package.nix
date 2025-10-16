{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.31.5-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-pmZturc7b3wd+qgSQPNzeY0LoMTF82dqUgOe8NfPeZw=";
  };

  vendorHash = "sha256-X/+yi04FkN8hauqeFytagIdfigb6EGTvv8tVrlm7MGw=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags ];
  };
}
