{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.  */
  version = "0.16.1";

  src = fetchFromGitHub {
    owner  = "tilt-dev";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0h3kaq22kg03gi6iffp471ap272lch8x566w7cq25hcdq78hq2v7";
  };
  vendorSha256 = "1yzqkmjacvzabhw7l70pf3fqkxjd4r1vjniaakwf5k3mr7sj077n";

  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version} -X main.date=2020-07-23" ];

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = "https://tilt.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
