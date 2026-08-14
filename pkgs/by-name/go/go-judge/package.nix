{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-judge";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iC26hZT4jD0Z3wADxnSXkUaBnBmxWXY3WNb46cseb/Q=";
  };

  vendorHash = "sha256-LQnndEO4TFsLvxxfhifDmufjdFhsqOt4jBUqc38NuD0=";

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${finalAttrs.version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = lib.licenses.mit;
    mainProgram = "go-judge";
    maintainers = with lib.maintainers; [ criyle ];
  };
})
