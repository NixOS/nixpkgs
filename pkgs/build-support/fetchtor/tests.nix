{
  testers,
  fetchtor,
  fetchFromGitLab,
  ...
}:
let
  domain = "eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion";
in
{
  viaGit = testers.invalidateFetcherByDrvHash fetchtor {
    name = "fetchgit-tor-source";
    url = "http://${domain}/tpo/core/tor";
    rev = "933c5491db00c703d5d8264fdabd5a5b10aff96f";
    hash = "sha256-o6Wpso8GSlQH39GpH3IXZyrVhdP8pEYFxLDq9a7yHX0=";
  };

  viaZip = testers.invalidateFetcherByDrvHash fetchtor {
    name = "fetchzip-tor-source";
    url = "http://${domain}/tpo/core/tor/-/archive/933c5491db00c703d5d8264fdabd5a5b10aff96f/tor-933c5491db00c703d5d8264fdabd5a5b10aff96f.zip";
    hash = "sha256-o6Wpso8GSlQH39GpH3IXZyrVhdP8pEYFxLDq9a7yHX0=";
  };

  viaFetchUrl = testers.invalidateFetcherByDrvHash fetchtor {
    name = "fetchurl-tor-source";
    url = "http://${domain}/tpo/core/tor/-/raw/933c5491db00c703d5d8264fdabd5a5b10aff96f/Cargo.lock";
    hash = "sha256-oX4WbsscLADgJ5o+czpueyAih7ic0u4lZQs7y1vMA3A=";
  };

  viaFetchFromGitLab = testers.invalidateFetcherByDrvHash fetchtor {
    name = "gitlab-tor-source";
    fetcher = fetchFromGitLab;
    protocol = "http";
    inherit domain;
    owner = "tpo/core";
    repo = "tor";
    rev = "933c5491db00c703d5d8264fdabd5a5b10aff96f";
    hash = "sha256-o6Wpso8GSlQH39GpH3IXZyrVhdP8pEYFxLDq9a7yHX0=";
  };
}
