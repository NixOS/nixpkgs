{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  dashing,
}:

buildGoModule (finalAttrs: {
  pname = "dashing";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "technosophos";
    repo = "dashing";
    rev = finalAttrs.version;
    hash = "sha256-CcEgGPnJGrTXrgo82u5dxQTB/YjFBhHdsv7uggsHG1Y=";
  };

  vendorHash = "sha256-XeUFmzf6y0S82gMOzkj4AUNFkVvkVOwauYpqY4jeWLM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = dashing;
  };

  meta = {
    description = "Dash Generator Script for Any HTML";
    homepage = "https://github.com/technosophos/dashing";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "dashing";
  };
})
