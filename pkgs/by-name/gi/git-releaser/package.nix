{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "git-releaser";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "git-releaser";
    repo = "git-releaser";
    rev = "refs/tags/v${version}";
    hash = "sha256-nKmHTqnpWoWMyXxsD/+pk+uSeqZSG18h2T6sJ/wEr/w=";
  };

  vendorHash = "sha256-RROA+nvdZnGfkUuB+ksUWGG16E8tqdyMQss2z/XWGd8=";

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
