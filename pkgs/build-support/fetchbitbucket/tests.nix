{ testers, fetchFromBitbucket, ... }:
{
  withEncodedWhitespace = testers.invalidateFetcherByDrvHash fetchFromBitbucket {
    name = "withWhitespace";
    owner = "tetov";
    repo = "fetchbitbucket_tester";
    rev = "tag%20with%20encoded%20spaces";
    sha256 = "sha256-Nf1Cvbx7Sbab8EeSSBU5baLBiuFYiQtITED+f4tfjC0=";
  };

  withoutWhitespace = testers.invalidateFetcherByDrvHash fetchFromBitbucket {
    name = "withoutWhitespace";
    owner = "tetov";
    repo = "fetchbitbucket_tester";
    rev = "main";
    sha256 = "sha256-eTd773gE1z4+Fl2YPBbbsrADD4Dr7sFGoOWgphXUhtE=";
  };
}
