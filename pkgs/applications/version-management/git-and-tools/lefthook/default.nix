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

  modSha256 = "0ih11gw2y9dhv3zw1fzjmdfjln5h6zg1bj7sl68cglf6743siqnq";

  meta = with stdenv.lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
