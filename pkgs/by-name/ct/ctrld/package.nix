{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "ctrld";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Control-D-Inc";
    repo = "ctrld";
    rev = "v${version}";
    hash = "sha256-vFXCBonJCZWFy+sKXDQ55ykFb67Sj1GdfuMtKIf4+5I=";
  };

  vendorHash = "sha256-il3jA4Dtfs1GMyL3IEgmzRDOIsKViovBqhtsvzwgafQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  # Requires network
  doCheck = false;

  passthru.tests = nixosTests.ctrld;

  meta = with lib; {
    description = "A highly configurable, multi-protocol DNS forwarding proxy";
    homepage = "https://github.com/Control-D-Inc/ctrld";
    license = licenses.mit;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "ctrld";
  };
}
