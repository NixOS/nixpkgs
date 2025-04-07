{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gh-skyline";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${version}";
    hash = "sha256-2i1f3iOrabTc+r5iUzghF3sJ7vgpTC1dmzY/z6h/oCg=";
  };

  vendorHash = "sha256-g4YqNts50RUBh1Gu9vSI29uvk0iHSnMgI1+KBFm5rNI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate a 3D model of your GitHub contribution history";
    homepage = "https://github.com/github/gh-skyline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "gh-skyline";
  };
}
