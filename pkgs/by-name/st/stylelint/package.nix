{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.11.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-mJGZ7zZ9Fi1VEVHWKu9CmKJsCLdmiHe3mqoGM0OGTRw=";
  };

  npmDepsHash = "sha256-RgXZgNEfx76XLrB4E8r/+a0Pi+82PVb/TOeUa0gFhTY=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
