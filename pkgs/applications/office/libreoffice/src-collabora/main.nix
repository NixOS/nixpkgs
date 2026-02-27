{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  rev = "cp-25.04.9-2";
  hash = "sha256-Pui22a/qGxb5EpU8fRLnp5dAXDOUSD4ptOPwg2I4Clk=";
  fetchSubmodules = false;
}
