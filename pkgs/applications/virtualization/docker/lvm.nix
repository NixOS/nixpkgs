{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "docker-lvm-plugin-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/projectatomic/docker-lvm-plugin";

  src = fetchFromGitHub {
    owner = "projectatomic";
    repo = "docker-lvm-plugin";
    rev = "8647404eed561d32835d6bc032b1c330ee31ed5b";
    sha256 = "0z9anmx35s59gqdsbxg0wn3kafk7yiazq8xb7faj993g1y3wd71n";
  };

  meta = with stdenv.lib; {
    description = "Docker volume plugin for LVM volumes";
    license = licenses.lgpl3;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
