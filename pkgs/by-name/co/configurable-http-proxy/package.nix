{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "configurable-http-proxy";
  version = "4.5.6";

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "configurable-http-proxy";
    rev = version;
    hash = "sha256-nj6+GmBw5YSQs23rWVh3qU4jdzRdbPyx43QmZ3LRwn4=";
  };

  npmDepsHash = "sha256-3HzVI7L1BH9PEBcb7CWWRQqWdSlWiCTo0qqnlSHGn7Y=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/jupyterhub/configurable-http-proxy/blob/${src.rev}/CHANGELOG.md";
    description = "Configurable-on-the-fly HTTP Proxy";
    homepage = "https://github.com/jupyterhub/configurable-http-proxy";
    license = lib.licenses.bsd3;
    mainProgram = "configurable-http-proxy";
  };
}
