{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "inshellisense";
    tag = version;
    hash = "sha256-5gVFP1AFFP4o9MNUqkRtgrTkKuMb37CU/c8TcrwZkRY=";
  };

  # Building against nodejs-24 is not yet supported by upstream.
  # https://github.com/microsoft/inshellisense/issues/369
  nodejs = nodejs_22;

  npmDepsHash = "sha256-JP9m624XxR6M18+jSWEh/E8WxIUjHnPN1eKW4iqUmSc=";

  meta = {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
  };
}
