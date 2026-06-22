{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint-config-standard";
  version = "40.0.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint-config-standard";
    tag = version;
    hash = "sha256-tiT3m2v98kfKnzpTEyrapboawSFPbrrxWDilOKXDlrI=";
  };

  npmDepsHash = "sha256-IFqm0lJ3Pzr2qVBmGLIzi5PMqHN5pf4RkLAKGqMU5HQ=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Standard shareable config for Stylelint";
    mainProgram = "stylelint";
    homepage = "https://github.com/stylelint/stylelint-config-standard";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mib ];
  };
}
