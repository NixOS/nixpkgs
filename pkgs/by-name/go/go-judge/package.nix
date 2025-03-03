{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dq3gs5iDpunI4NKuIJL3132jrJpyeuqnD/Z+WKTBLHg=";
  };

  vendorHash = "sha256-phX5H1ImnBhcWWFnzoIsf/xgxw4HtTKFBvjtymKS7O0=";

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
  };
}
