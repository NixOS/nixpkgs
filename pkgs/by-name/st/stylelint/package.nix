{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.9.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-hSedkJoIWI2JnbixAr2xMsdFgGiHJ6gzJUachdgrGNI=";
  };

  npmDepsHash = "sha256-9w6wBXjrf1aDjGVzJkYtBRDHtJg9xCGE70qZIvyFtOQ=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
