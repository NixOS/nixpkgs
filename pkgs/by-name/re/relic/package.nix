{ lib
, buildGoModule
, fetchFromGitHub
, testers
, relic
}:

buildGoModule rec {
  pname = "relic";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8pqLV4NWCI35FGe2NNqjatTAlVyvx1mskbcR/NacUvI=";
  };

  vendorHash = "sha256-x0EqKotZJny+7FtRvdXWUkPpG0jntFGe/IpNzKVL2pI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = relic;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "Service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    mainProgram = "relic";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
  };
}
