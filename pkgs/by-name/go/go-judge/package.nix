{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i6c7uKnnyO+tyQwrEFvyPaw3N9VfFB+L7xYHsUPy6RM=";
  };

  vendorHash = "sha256-WAO7nMDm7/KuDOIZSopRVKUVWmjDl30d95NWBuebiE4=";

  tags = [ "nomsgpack" ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://github.com/criyle/go-judge";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
  };
}
