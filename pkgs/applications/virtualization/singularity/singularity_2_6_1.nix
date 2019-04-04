{ stdenv, callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {

  name = "singularity-${version}";
  
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "sylabs";
    repo = "singularity";
    rev = "v${version}";
    sha256 = "1wpsd0il2ipa2n5cnbj8dzs095jycdryq2rx62kikbq7ahzz4fsi";
  };

}
