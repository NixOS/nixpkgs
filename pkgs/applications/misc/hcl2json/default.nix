{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RBzx6TxkR6GwMGHIpkJeswZ3zV4hRf38rTGUO6u2OI4=";
  };

  vendorHash = "sha256-G/2bSFCXbph0bVjmWmcFgv4i/pCOQHhYxsVRVkpHPo4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "hcl2json";
  };
}
