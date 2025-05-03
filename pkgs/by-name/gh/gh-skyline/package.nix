{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gh-skyline";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-skyline";
    tag = "v${version}";
    hash = "sha256-jcdOLoyOXq270SaObMpCD+ts6Hj8wqSAjUZWEg3F9+w=";
  };

  vendorHash = "sha256-rCFHYofUQlfRMP7bJav2se7oAkE7rS8KJl1n8kCsSag=";

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
