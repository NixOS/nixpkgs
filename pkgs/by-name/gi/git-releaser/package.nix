{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "git-releaser";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "git-releaser";
    repo = "git-releaser";
    rev = "refs/tags/v${version}";
    hash = "sha256-rgnOXon68QMfVbyYhERy5z2pUlLCBwum7a/U9kdp5M0=";
  };

  vendorHash = "sha256-O6Rqdf6yZvW8aix51oIziip+WcVIiyDZZ2VOQfwP8Fs=";

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
