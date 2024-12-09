{
  lib,
  buildNpmPackage,
  fetchFromGitHub
}:

buildNpmPackage {
  pname = "fixjson";
  version = "1.1.2-unstable-2021-01-05";

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "fixjson";
    # Upstream has no tagged releases, but this commit bumps version
    rev = "d0483f9cc59896ea59bb16f906f770562d332000";
    hash = "sha256-Mu7ho0t5GzFYuBK6FEXhpsaRxn9HF3lnvMxRpg0aqYI=";
  };

  npmDepsHash = "sha256-tnsgNtMdnrKYxcYy9+4tgp1BX+o8e5/HUDeSP5BOvUQ=";

  meta = {
    description = "JSON Fixer for Humans using (relaxed) JSON5";
    homepage = "https://github.com/rhysd/fixjson";
    license = lib.licenses.mit;
    mainProgram = "fixjson";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
