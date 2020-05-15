{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "0.7.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Arkweid";
    repo = "lefthook";
    sha256 = "14rcvbzzrx0m3xijl8qhw5l2h0q10hqzad2hqm3079g893f2qad0";
  };

  vendorSha256 = "1pdrw4vwbj9cka2pjbjvxviigfvnrf8sgws27ixwwiblbkj4isc8";

  meta = with stdenv.lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}