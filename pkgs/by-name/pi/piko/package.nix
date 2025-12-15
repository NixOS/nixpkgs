{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "piko";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "andydunstall";
    repo = "piko";
    tag = "v${version}";
    hash = "sha256-2fQQNVUnQVhDHVJwpLs/1Is9N9paq9izvrlrFVzRgfk=";
  };

  vendorHash = "sha256-pkUVp9O8VrfRmZtWDgFj/hqlqQsfEhnPPe6Hi92d3eU=";

  ldflags = [
    "-X github.com/andydunstall/piko/pkg/build.Version=${version}"
  ];

  meta = {
    description = "Open-source alternative to Ngrok, designed to serve production traffic and be simple to host (particularly on Kubernetes)";
    homepage = "https://github.com/andydunstall/piko";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ echoz ];
    mainProgram = "piko";
  };
}
