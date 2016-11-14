{ stdenv, buildGoPackage, fetchFromGitHub, libvirt, libvirt-glib, kvm, docker-machine }:

buildGoPackage rec {
    name = "docker-machine-kvm-${version}";
    version = "20160801-${stdenv.lib.strings.substring 0 7 rev}";
    rev = "37bb4cc6778c35860a0ce502f3a2d1a96dc3fd67";

    goPackagePath = "github.com/dhiltgen/docker-machine-kvm";

    subPackages = [ "cmd/docker-machine-driver-kvm" ];

    propagatedBuildInputs = [ libvirt libvirt-glib kvm docker-machine ];

    src = fetchFromGitHub {
      inherit rev;
      owner = "dhiltgen";
      repo = "docker-machine-kvm";
      sha256 = "0za6vjbi5blg4bbrd0fs581l52n6frlkj4vwq8d7s8jpkb9ncvbq";
    };

    goDeps = ./deps.nix;

      meta = with stdenv.lib; {
    homepage = https://docs.docker.com/machine/;
    description = "This is a plugin for Docker Machine that enable kvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.unix;
  };
}
