{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "certinfo-go";
  version = "0.1.43";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${version}";
    hash = "sha256-vXNk4DrElWmV7yxWEiLZexJQzVBUY08fF0in6hpBwjA=";
  };

  vendorHash = "sha256-rAXnnd9E3HFvmbI+dIJj0F81NwXXD53QATNNmlOpBRM=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys, ...";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
