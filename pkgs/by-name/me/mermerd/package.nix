{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mermerd,
}:

buildGoModule rec {
  pname = "mermerd";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    tag = "v${version}";
    hash = "sha256-18GM/mb32MPI128ytM/Im+LO+N9cW1HoZ7M4tP2+i0o=";
  };

  vendorHash = "sha256-r5/mztbAwj25QevcB1iYb6fJzNACPtJEurkbD1Iq7dM=";

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
