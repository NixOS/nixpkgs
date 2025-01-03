{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "ares-cli";
  version = "3.1.2";
  src = fetchFromGitHub {
    owner = "webos-tools";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-xiyXJ95MVG06ZoAsC4fIZHQn7lnKumlM3f9MB4uQ7Xc=";
  };

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-QtCssL8LLDafRbdB9sWWjP49fjOk+9y3h9xdQ1hIudg=";

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
