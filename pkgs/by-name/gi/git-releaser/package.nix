{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "git-releaser";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "git-releaser";
    repo = "git-releaser";
    rev = "refs/tags/v${version}";
    hash = "sha256-owIXiLLnCkda9O0C0wW0nEuwXC4hipNpR9fdFqgbWts=";
  };

  vendorHash = "sha256-dTyHKSCEImySu6Tagqvh6jDvgDbOTL0fMUOjFBpp64k=";

  ldflags = [ "-X main.version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool for creating Git releases based on Semantic Versioning";
    homepage = "https://github.com/git-releaser/git-releaser";
    changelog = "https://github.com/git-releaser/git-releaser/releases/tag/v${version}";
    maintainers = with maintainers; [ jakuzure ];
    license = licenses.asl20;
    mainProgram = "git-releaser";
  };
}
