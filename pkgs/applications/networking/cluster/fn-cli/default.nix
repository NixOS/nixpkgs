{ lib, buildGoModule, fetchFromGitHub, docker }:

buildGoModule rec {
  pname = "fn";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "fnproject";
    repo = "cli";
    rev = version;
    sha256 = "sha256-Gf4YxxyNALicb9GPpOW+Kzb2xrwcAU1XYOzXochH0LI=";
  };

  vendorSha256 = null;

  subPackages = ["."];

  buildInputs = [
    docker
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/fn
  '';

  meta = with lib; {
    description = "Command-line tool for the fn project";
    homepage = "https://fnproject.io";
    license = licenses.asl20;
    maintainers = [ maintainers.c4605 ];
  };
}
