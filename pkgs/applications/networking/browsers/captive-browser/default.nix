{ fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "captive-browser";
  version = "2019-04-14";
  goPackagePath = name;

  src = fetchFromGitHub {
    owner  = "FiloSottile";
    repo   = "captive-browser";
    rev    = "b96bd8a2aca14505cf8432935ee9add15ec39a57";
    sha256 = "1k7r7rckb81m11hr6nzw3w8wx76hbl4740xg4818vdm5py1hv5ij";
  };
}
