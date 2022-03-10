{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.  */
  version = "0.25.2";

  src = fetchFromGitHub {
    owner  = "tilt-dev";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-L5pXq4vfus8gpQMO+j2+WXMPkk3sv3WeeeYrBFd+w7s=";
  };
  vendorSha256 = null;

  subPackages = [ "cmd/tilt" ];

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = "https://tilt.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
