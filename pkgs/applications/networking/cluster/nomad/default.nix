{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.9.3";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "0hn9rr5v2y2pw0pmn27gz8dx5n964dsaf48sh0jhwc95b5q1rjwr";
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
