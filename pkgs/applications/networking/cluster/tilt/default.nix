{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "tilt";
  name    = "${pname}-${version}";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.8.1";
  rev = "9ce987dd0eeb66df993f8d232b57ff3e4d380dda";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = "tilt";
    rev    = "${rev}";
    sha256 = "0ybzj2csmjc7zlkprcyy5cnh9dxgngcx3wd6n43kawi5db0lvjn4";
  };

  goPackagePath = "github.com/windmilleng/tilt";
  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2019-04-29");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
