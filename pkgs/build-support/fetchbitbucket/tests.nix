{ testers, fetchFromBitbucket, ... }:
{
  withEncodedWhitespace = testers.invalidateFetcherByDrvHash fetchFromBitbucket {
    name = "withWhitespace";
    owner = "tetov";
    repo = "fetchbitbucket_tester";
    tag = "tag%20with%20encoded%20spaces";
    sha256 = "sha256-Nf1Cvbx7Sbab8EeSSBU5baLBiuFYiQtITED+f4tfjC0=";
  };

  withEncodedWhitespaceGit = testers.invalidateFetcherByDrvHash fetchFromBitbucket {
    name = "withWhitespaceGit";
    owner = "tetov";
    repo = "fetchbitbucket_tester";
    tag = "tag%20with%20encoded%20spaces";
    sha256 = "sha256-Nf1Cvbx7Sbab8EeSSBU5baLBiuFYiQtITED+f4tfjC0=";
    forceFetchGit = true;
  };

  withoutWhitespace = testers.invalidateFetcherByDrvHash fetchFromBitbucket {
    name = "withoutWhitespace";
    owner = "tetov";
    repo = "fetchbitbucket_tester";
    rev = "6b611eb75c7b3bf04b510dfc1268284039d55542";
    sha256 = "sha256-eTd773gE1z4+Fl2YPBbbsrADD4Dr7sFGoOWgphXUhtE=";
  };
}
