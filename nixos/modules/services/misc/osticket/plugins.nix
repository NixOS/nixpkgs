{ fetchFromGitHub, ... }:
{
  slack = fetchFromGitHub {
    owner = "clonemeagain";
    repo = "osticket-slack";
    rev = "235436a8fb92168f01fa4d4e55336d203c6eded4";
    sha256 = "sha256:0ffy8spkq24kgbqi89l5paxv1ba8m2ky3qph8bs4pz04j89g0b2r";
  };
}
