{ lib, fetchFromGitHub }:

rec {
  version = "0.6.7.2";

  src = fetchFromGitHub {
    owner = "RetroShare";
    repo = "RetroShare";
    rev = "v${version}";
    sha256 = "sha256-1A1YvOWIiWlP1JPUTg5Z/lxVGCBv4tCPf5sZdPogitU=";
    fetchSubmodules = true;
  };

  RSVersionFlags = [
    # These values are normally found from the .git folder
    "DRS_MAJOR_VERSION=${lib.versions.major version}"
    "RS_MINOR_VERSION=${lib.versions.minor version}"
    "RS_MINI_VERSION=${lib.versions.patch version}"
    "RS_EXTRA_VERSION=.2"
  ];
}
