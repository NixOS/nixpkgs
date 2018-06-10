{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nomad-${version}";
  version = "0.7.1";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "0hn80dqzxkwvk1zjk6px725mb2i3c06smqfj0yyjz96vgf7qbqy2";
  };

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri ];
  };
}
