{ stdenv, buildGoModule, fetchFromGitHub, fetchgx, gx-go }:

buildGoModule rec {
  pname = "ipfs-cluster";
  version = "0.13.0";
  rev = "v${version}";

  vendorSha256 = "00fkyxxi4iz16v0j33270x8qrspqpsv9j6csnikjy0klyb038pfq";

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipfs-cluster";
    inherit rev;
    sha256 = "0jf3ngxqkgss5f1kifp5lp3kllb21jxc475ysl01ma8l3smqdvya";
  };

  meta = with stdenv.lib; {
    description = "Allocate, replicate, and track Pins across a cluster of IPFS daemons";
    homepage = "https://cluster.ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik ];
  };
}
