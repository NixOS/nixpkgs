{ testers, fetchFromGitHub, ... }:
{
  simple-rev = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "simple-rev";
    owner = "smallstep";
    repo = "certificates";
    rev = "0cf1c5688708ec4a910c007d7f151c617b722268";
    hash = "sha256-5W39Nc6WuxhrXbEfPWMaWWAUX6UnjYqlEAPlDCeYgrY=";
  };
  simple-tag = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "simple-tag";
    owner = "smallstep";
    repo = "certificates";
    tag = "v0.28.3";
    hash = "sha256-5W39Nc6WuxhrXbEfPWMaWWAUX6UnjYqlEAPlDCeYgrY=";
  };
  pureExportSubst-simple = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "export-subst-simple";
    owner = "smallstep";
    repo = "certificates";
    tag = "v0.28.3";
    hash = "sha256-5W39Nc6WuxhrXbEfPWMaWWAUX6UnjYqlEAPlDCeYgrY=";
    pureExportSubst = true;
  };
  pureExportSubst-noop = testers.invalidateFetcherByDrvHash fetchFromGitHub {
    name = "export-subst-noop";
    owner = "smallstep";
    repo = "certificates";
    tag = "v0.8.4"; # They didn't have export-subst at that point
    hash = "sha256-pHs87xXu1ueMMlmUSzrDKYnD1yxpxU2UvOFtjI9ATCw=";
    pureExportSubst = true;
  };
}
