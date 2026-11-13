{ fetchgit, ... }:
fetchgit {
  url = "https://gerrit.libreoffice.org/core";
  tag = "cp-25.04.9-4";
  hash = "sha256-9NE5GCIUUyinteFUBBkmV+ZwT7rfnVvynQqhumlYYEc=";
  fetchSubmodules = false;
}
