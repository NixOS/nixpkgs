{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.11.3";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "035czgr0rn6gcv24vnlr35n9yvy0fwq4spdzsc76gfxckcbcmzz0";
  };

  goPackagePath = "github.com/windmilleng/tilt";

  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2020-01-25");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
