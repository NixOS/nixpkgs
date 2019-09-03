{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  pname = "ipget";
  version = "0.3.2";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipget";

  extraSrcPaths = [
    (fetchgx {
      inherit  src;name = "${pname}-${version}";
      sha256 = "07l9hpkhk5phr95zp1l5wd3ii38bw91hy4dlw2rsfbzcsc8bq4s8";
    })
  ];

  goDeps = ../../../tools/package-management/gx/deps.nix;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    inherit rev;
    sha256 = "1ljf5ddvc1p5swmgn4m1ivfj74fykk56myk2r9c4grdjzksf4a15";
  };

  meta = with stdenv.lib; {
    description = "Retrieve files over IPFS and save them locally";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
