{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.3.2";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "1m2pdragpzrq0xbmnba039iiyhb16wirj3n1s52z5r8r0mr7drai";
  };

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    license = licenses.mpl20;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rushmorem ];
  };
}
