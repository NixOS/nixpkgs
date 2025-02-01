{ lib, buildNpmPackage, fetchFromGitHub, nix-update-script }:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f/ccGh31qT+euuGA3RRyiUYl+wpxazZHs5R8xehX3Zk=";
  };

  npmDepsHash = "sha256-t71SfoPYVFLWcrjv2ErWazDeaVTO4W46g4lFler86Sc=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
    mainProgram = "terminal-stocks";
  };
}
