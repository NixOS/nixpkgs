{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "tilt";
  name    = "${pname}-${version}";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.8.8";
  rev = "344dc1dc61ffe2c29606b105cea0df79fb5897f5";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = "tilt";
    rev    = "${rev}";
    sha256 = "13yda6m2d92mmc9w4k8ngdxmpqcqf86bkrvcpmpaby848ls1yx8g";
  };

  goPackagePath = "github.com/windmilleng/tilt";
  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2019-06-03");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
