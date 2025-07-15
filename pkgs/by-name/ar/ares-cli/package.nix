{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "ares-cli";
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "webos-tools";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-L8suZDtXVchVyvp7KCv0UaceJqqGBdfopd5tZzwj3MY=";
  };

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-ATIxe/sulfOpz5KiWauDAPZrlfUOFyiTa+5ECFbVd+0=";

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
