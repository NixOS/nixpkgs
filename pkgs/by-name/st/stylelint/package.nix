{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.19.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-KYUNKA/KJXfRiGkhzkBKkiuEMJAwpkt4FXwx/oJQdq4=";
  };

  npmDepsHash = "sha256-5KWs4AboLHJBXJaDXAs30e0e9PAncFQzGHdNDxG8Lpo=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
