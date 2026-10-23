{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-judge";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VUhIqld49w849/cQCJ5ZKxz9+pahk3I0BUU2WQajgME=";
  };

  vendorHash = "sha256-qKxs3FF9kuvq/vZpI89HOzs2FBuAVS3ikih8RyT6Xfc=";

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
