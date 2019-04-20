{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "tilt";
  name    = "${pname}-${version}";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
     running in development environment and try to serve assets from the
     source tree, which is not there once build completes.  */
  version = "0.7.13";
  rev = "67cd823b2a07c7bb2bcb919c0963e8f23e22d57e";

  src = fetchFromGitHub {
    owner  = "windmilleng";
    repo   = "tilt";
    rev    = "${rev}";
    sha256 = "0cfmdd6wsczcmy6fkd418rvancx4qy1c3pzq9jbfsy4innhh51j7";
  };

  goPackagePath = "github.com/windmilleng/tilt";
  subPackages = [ "cmd/tilt" ];

  buildFlagsArray = ("-ldflags=-X main.version=${version} -X main.date=2019-04-18");

  meta = with stdenv.lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = https://tilt.dev/;
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];
  };
}
