{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "refs/tags/cp-24.04.5-4";
  hash = "sha256-OJ3R8qs8/R8QnXGCRgn/ZJK7Nn8cWwYbZxjEWg0VpBc=";
  fetchSubmodules = false;
}
