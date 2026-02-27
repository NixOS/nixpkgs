{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "coda-25.04.8.1-1";
  hash = "sha256-322yzoQPeQa6Dm6pcpP/KlrPHPmDsMHtbL248B2FUgs=";
  fetchSubmodules = false;
}
