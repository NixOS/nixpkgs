{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.9.4";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "1jgvnmmrz7ffpm6aamdrvklj94n7b43swk9cycqhlfbnzijianpn";
  };

  # We disable Nvidia GPU scheduling on Linux, as it doesn't work there:
  # Ref: https://github.com/hashicorp/nomad/issues/5535
  buildFlags = stdenv.lib.optionalString (stdenv.isLinux) "-tags nonvidia";

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri ];
  };
}
