{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "brig-${version}";
  version = "0.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/sahib/brig";
  subPackages = ["."];

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "brig";
    inherit rev;
    sha256 = "01hpb6cvq8cw21ka74jllggkv5pavc0sbl1207x32gzxslw3gsvy";
  };

  meta = with stdenv.lib; {
    description = "File synchronization on top of ipfs with git like interface and FUSE filesystem";
    homepage = https://github.com/sahib/brig;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ offline ];
  };
}
