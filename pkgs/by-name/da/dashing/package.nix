{ lib, buildGoModule, fetchFromGitHub, testers, dashing }:

buildGoModule rec {
  pname = "dashing";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "technosophos";
    repo = pname;
    rev = version;
    hash = "sha256-CcEgGPnJGrTXrgo82u5dxQTB/YjFBhHdsv7uggsHG1Y=";
  };

  vendorHash = "sha256-XeUFmzf6y0S82gMOzkj4AUNFkVvkVOwauYpqY4jeWLM=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = dashing;
  };

  meta = with lib; {
    description = "Dash Generator Script for Any HTML";
    homepage = "https://github.com/technosophos/dashing";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "dashing";
  };
}
