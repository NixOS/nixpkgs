{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.5.4";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "0x7bi6wq7kpqv3wfhk5mqikj4hsb0f6lx867xz5l9cq3i39b5gj3";
  };

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri ];
  };
}
