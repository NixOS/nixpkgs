{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mermerd,
}:

buildGoModule rec {
  pname = "mermerd";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    tag = "v${version}";
    hash = "sha256-xyqWGK9Ko4kdHMC6pbXXxdzIufsOb7Vq2Nh45f45D9w=";
  };

  vendorHash = "sha256-Uu/L1wL1999hHydUSVvDNaCKy8RlRMKdDEhERgryjBY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  # the tests expect a database to be running
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = mermerd;
      command = "mermerd version";
    };
  };

  meta = {
    description = "Create Mermaid-Js ERD diagrams from existing tables";
    mainProgram = "mermerd";
    homepage = "https://github.com/KarnerTh/mermerd";
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ austin-artificial ];
  };
}
