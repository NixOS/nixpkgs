{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "refs/tags/cp-24.04.5-4";
  hash = "sha256-27uLK1u8XWNigxZUCUu8nNZP3p5eFUsS2gCcfSYJK2k=";
  fetchSubmodules = true;
}
