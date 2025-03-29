{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gh-skyline";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${version}";
    hash = "sha256-j8RAuujlze589+W+jvXJq1b7YX3uf+sd8qTvyZeKYUc=";
  };

  vendorHash = "sha256-rfv9KTTWs68pqSdgWo9dIn+PTe+77ZMOEhG0P37QwKo=";

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
