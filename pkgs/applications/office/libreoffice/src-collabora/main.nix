{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "cp-25.04.8-3";
  hash = "sha256-kvP3OzF5rSb8q0qVMlH50fti6edR+EqQk7Rm5gPSJAA=";
  fetchSubmodules = false;
}
