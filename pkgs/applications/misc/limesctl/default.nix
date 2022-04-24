{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-52Tq6gKozM/IFUyAy8N+YDqlbcFNQw6b2tc268Zco6g=";
  };

  vendorSha256 = "sha256-7QEb5J5IaxisKjbulyHq5PGVeKAX022Pz+5OV5qD7Uo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
