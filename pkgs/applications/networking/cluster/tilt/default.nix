{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.10.13";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "02xlqgmmn1a7pz6sliharz8l9fbn2raxqkm75qxdqs1ncbvgc65k";
  };

  goPackagePath = "github.com/windmilleng/tilt";

  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2019-10-04");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
