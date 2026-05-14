{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "lightning-loop";
  version = "0.33.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LfVC/s7VNc3LvypjdSFo0s2Ssmhk1Lzm9ojWGqaNCmI=";
  };

  vendorHash = "sha256-pzcOKYw2kXfGUOBZmuUYuEfRUY8f1PSj30tvhttEwAk=";

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

  meta = {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      proofofkeags
      starius
    ];
  };
})
