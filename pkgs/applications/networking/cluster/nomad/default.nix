{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.4.1";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "093nljhibphhccjwxkylbvlc8dh8g2js36mlxxdh9nh21b3mghcs";
  };

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem ];
  };
}
