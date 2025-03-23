{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4KBMDqHw8EJGSDK9+jCZvaxkQymhw4RRGByrFngiIug=";
  };

  vendorHash = "sha256-FnX3u6DLB9qPE4+Hy/+00mD4U/6Pa+CsZoEroi7cNO0=";

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
