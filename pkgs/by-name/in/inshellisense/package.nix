{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "inshellisense";
    tag = version;
    hash = "sha256-X+M4uqWdk5gQvjhqc3tVDOgeI12FpBvsfx8+pO7CHcA=";
  };

  # Building against nodejs-24 is not yet supported by upstream.
  # https://github.com/microsoft/inshellisense/issues/369
  nodejs = nodejs_22;

  npmDepsHash = "sha256-670oGCuZhDLKe48hFL+gLMjmHM5YLGEawonG8PZTXpU=";

  meta = {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
  };
}
