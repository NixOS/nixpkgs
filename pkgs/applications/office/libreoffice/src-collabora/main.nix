{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "refs/tags/cp-25.04.1-1";
  hash = "sha256-WhNNKL1RC0hWi21wH5EJRZ8V8U7jk6z8h3E3mVR56zk=";
  fetchSubmodules = false;
}
