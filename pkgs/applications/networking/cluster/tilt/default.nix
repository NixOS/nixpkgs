{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.  */
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "tilt";
    rev = "v${version}";
    hash = "sha256-TNZE335tH50E96yJzD26U+JbVxjU746Wa/8YDGHFeto=";
  };

  vendorHash = null;

  subPackages = [ "cmd/tilt" ];

  ldflags = [ "-X main.version=${version}" ];

  meta = {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anton-dessiatov ];
  };
}
