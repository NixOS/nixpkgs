{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "ares-cli";
  version = "3.2.3";
  src = fetchFromGitHub {
    owner = "webos-tools";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-oRnmqptDlx6ZxiPAvkiDIYMWhzFpx2vHQXkDlCPU2vQ=";
  };

  nodejs = nodejs_22;

  dontNpmBuild = true;
  npmDepsHash = "sha256-qgCAXpywRa+TirP92lCcML9vnXfzHLkn1S/qZcUxR8c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://webostv.developer.lge.com/develop/tools/cli-introduction";
    description = "Collection of commands used for creating, packaging, installing, and launching web apps for LG webOS TV";
    longDescription = ''
      webOS CLI (Command Line Interface) provides a collection of commands used for creating, packaging, installing,
      and launching web apps in the command line environment. The CLI allows you to develop and test your app without using
      a specific IDE.
    '';
    mainProgram = "ares";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rucadi ];
  };
}
