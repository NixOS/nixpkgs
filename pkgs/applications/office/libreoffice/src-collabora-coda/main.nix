{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "coda-25.04.9.2-2";
  hash = "sha256-wQYMqHZVxCst3fIZY2pd60QZkTaiZ+rOPnA+gDGyEYU=";
  fetchSubmodules = false;
}
