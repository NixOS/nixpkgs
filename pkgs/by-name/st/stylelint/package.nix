{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "18.0.0-next.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-NjqgNiFDDjwdElobMXbAnUqcpaFLcBoi3rzjoZu51Wg=";
  };

  npmDepsHash = "sha256-sPrlxzwxyXLPDcfTxoSOZRO145MapL7KdcRK6afq16Q=";

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
