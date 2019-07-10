{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.9.2";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1kwama90bxmnylmj6hipnx5raiqq42dq31lb66xyd89fzbkdnzk4";
  };

  goPackagePath = "github.com/windmilleng/tilt";

  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2019-07-10");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
