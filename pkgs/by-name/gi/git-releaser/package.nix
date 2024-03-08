{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "git-releaser";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "git-releaser";
    repo = "git-releaser";
    rev = "refs/tags/v${version}";
    hash = "sha256-27xUsqFuAu02jYLi3LiTnVjifqZIr39lPwMfJea7a4A=";
  };

  vendorHash = "sha256-uKS7MwCak/CjnMjzFKqYypBVZFl+3hD1xVaOPvQV9E0=";

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
