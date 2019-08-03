{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "brig-${version}";
  version = "0.4.1";
  rev = "v${version}";

  goPackagePath = "github.com/sahib/brig";
  subPackages = ["."];

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "brig";
    inherit rev;
    sha256 = "0gi39jmnzqrgj146yw8lcmgmvzx7ii1dgw4iqig7kx8c0jiqi600";
  };

  meta = with stdenv.lib; {
    description = "File synchronization on top of ipfs with git like interface and FUSE filesystem";
    homepage = https://github.com/sahib/brig;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ offline ];
  };
}
