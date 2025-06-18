{ bossa, fetchFromGitHub }:

bossa.overrideAttrs (attrs: rec {
  pname = "bossa-arduino";
  version = "1.9.1-arduino2";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "BOSSA";
    rev = version;
    sha256 = "sha256-sBJ6QMd7cTClDnGCeOU0FT6IczEjqqRxCD7kef5GuY8=";
  };
})
