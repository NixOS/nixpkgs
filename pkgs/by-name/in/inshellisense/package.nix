{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "inshellisense";
    tag = version;
    hash = "sha256-7PgfDOFUHV9SyRnsP/6QWWwvge5Ib3bK97M5mqSJ1Lk=";
  };

  # Building against nodejs-24 is not yet supported by upstream.
  # https://github.com/microsoft/inshellisense/issues/369
  nodejs = nodejs_22;

  npmDepsHash = "sha256-SHIkFdf6p2JoBeUW/WfRX94Px+L1h3E/4BRk2WfIvSw=";

  meta = {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
  };
}
