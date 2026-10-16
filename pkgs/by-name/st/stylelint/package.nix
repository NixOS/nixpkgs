{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.14.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-r0a+Ls8Q0t7diKeUh3DNgXn5EaXGStyd4BMXIyu0Pv4=";
  };

  npmDepsHash = "sha256-Smf0Je1eruumDrKGMRBY515H6xsRFuFuRXMXgCQ4f+k=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
