{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
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

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage docs/loop.1
  '';

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [
      proofofkeags
      starius
    ];
  };
}
