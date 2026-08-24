{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "inshellisense";
    tag = version;
    hash = "sha256-Zo9ogCmkTwRqkvL1R/BnOGDZR1Hzmgegf19N2ZmVmkM=";
  };

  # Building against nodejs-24 is not yet supported by upstream.
  # https://github.com/microsoft/inshellisense/issues/369
  nodejs = nodejs_22;

  npmDepsHash = "sha256-d88ybpAwDkhxKyq9dgOMeoUbY7WVtqJUkk6mNp9Rsuk=";

  meta = {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
  };
}
