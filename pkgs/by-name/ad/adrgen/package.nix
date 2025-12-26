{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  adrgen,
}:

buildGoModule rec {
  pname = "adrgen";
  version = "0.4.1-beta";

  src = fetchFromGitHub {
    owner = "asiermarques";
    repo = "adrgen";
    tag = "v${version}";
    hash = "sha256-9EiJe5shhwbjLIvUQMUTSGTgCA+r3RdkLkPRPoWvZ3g=";
  };

  vendorHash = "sha256-RXwwv3Q/kQ6FondpiUm5XZogAVK2aaVmKu4hfr+AnAM=";

  passthru.tests.version = testers.testVersion {
    package = adrgen;
    command = "adrgen version";
    version = "v${version}";
  };

  meta = {
    homepage = "https://github.com/asiermarques/adrgen";
    description = "Command-line tool for generating and managing Architecture Decision Records";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "adrgen";
  };
}
