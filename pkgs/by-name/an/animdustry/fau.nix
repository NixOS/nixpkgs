{
  fetchFromGitHub,
  buildNimPackage,
}:
buildNimPackage {
  pname = "fau";
  version = "0-unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "fau";
    rev = "73f5fdb8e90cc95073e427c9403b8fa360846620";
    hash = "sha256-o0TaySlfc1+OPXfemFLb4Mi/gg41SGY7CmkqfhVyrF0=";
    fetchSubmodules = true;
  };

  lockFile = ./lock.json;
}
