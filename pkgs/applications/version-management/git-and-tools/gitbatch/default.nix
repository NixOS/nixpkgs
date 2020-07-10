{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gitbatch-unstable";
  version = "2019-12-19";

  goPackagePath = "github.com/isacikgoz/gitbatch";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = "gitbatch";
    rev = "381b0df7f86056c625c0d4d2d979733c1ee5def7";
    sha256 = "0613vfqdn3k0w7fm25rqnqdr67w9vii3i56dfslqcn1vqjfrff3q";
  };

  meta = with stdenv.lib; {
    description = "Running git UI commands";
    homepage = "https://github.com/isacikgoz/gitbatch";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
    platforms = with platforms; linux;
  };
}
