{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "ares-cli";
  version = "3.1.3";
  src = fetchFromGitHub {
    owner = "webos-tools";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-V/YMDmed2VlJibeWmtiY6ftSiZMZhBcppwGXXjtLc5M=";
  };

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-Vf38Hw0rXMfP3MWBrDo9oDzF1KyHMOjxrmL/VMpL3mU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://webostv.developer.lge.com/develop/tools/cli-introduction";
    description = "A collection of commands used for creating, packaging, installing, and launching web apps for LG webOS TV.";
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
