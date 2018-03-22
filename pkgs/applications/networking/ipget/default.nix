{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "ipget-${version}";
  version = "0.2.5";
  rev = "v${version}";

  goPackagePath = "github.com/ipfs/ipget";
  
  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "1d4w8zl5mcppn3d4bl7qdkiqlf8gi3z2a62nygx17bqpa3da8cf3";
    })
  ];
 
  goDeps = ../../../tools/package-management/gx/deps.nix;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "ipget";
    inherit rev;
    sha256 = "0a8yxqhl469ipiznrgkp3yi1xz3xzcbpx60wabqppq8hccrdiybk";
  };

  meta = with stdenv.lib; {
    description = "Retrieve files over IPFS and save them locally";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
