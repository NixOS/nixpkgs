# opentoonz's source archive contains both opentoonz's source and a modified
# version of libtiff that opentoonz requires.

{ fetchFromGitHub, }: rec {
  versions = {
    opentoonz = "1.4.0";
    libtiff = "4.0.3";
  };

  src = fetchFromGitHub {
    owner = "opentoonz";
    repo = "opentoonz";
    rev = "v${versions.opentoonz}";
    sha256 = "0vgclx2yydsm5i2smff3fj8m750nhf35wfhva37kywgws01s189b";
  };
}
