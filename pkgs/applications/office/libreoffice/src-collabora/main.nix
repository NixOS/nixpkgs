{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "refs/tags/cp-24.04.13-2";
  hash = "sha256-m+kNUxpHwr7dfWsmvM9FSzR2YvTWYpeawOr8YH3b700=";
  fetchSubmodules = false;
}
