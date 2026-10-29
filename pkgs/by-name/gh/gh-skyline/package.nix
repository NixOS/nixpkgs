{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-skyline";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LuBmz/gK1zT9y2eWrwxYWItxFftu2X3cjMBi7kvhAoI=";
  };

  vendorHash = "sha256-4irClPrNagFA2fee+QmxlPn8Xg2WlFupaflmR0/+UOY=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a 3D model of your GitHub contribution history";
    homepage = "https://github.com/github/gh-skyline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "gh-skyline";
  };
})
