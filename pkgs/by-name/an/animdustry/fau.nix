{
  fetchFromGitHub,
  buildNimPackage,
}:
buildNimPackage {
  pname = "fau";
  version = "0-unstable-2022-05-14";

  src = fetchFromGitHub {
    owner = "Anuken";
    repo = "fau";
    rev = "73df4a699873d0f82fd612a2a2ac63c21d3f2233";
    hash = "sha256-9zwmFinDJV4+R/aiVVOQ/Bv30jX7NHJyufzMNWHGA+k=";
    fetchSubmodules = true;
  };

  requiredNimVersion = 1;
  lockFile = ./lock.json;
}
