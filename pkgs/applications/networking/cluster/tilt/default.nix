{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.  */
  version = "0.18.1";

  src = fetchFromGitHub {
    owner  = "tilt-dev";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1sdb2x06va0j9cxdwz95dklv2csq0s596wjsjqi4sq65y9bxjr7i";
  };
  vendorSha256 = null;

  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = "https://tilt.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
