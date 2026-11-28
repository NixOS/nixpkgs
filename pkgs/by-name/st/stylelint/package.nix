{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-G12boERiERnMJsrXnfcemt77r4Az6GjWYO5YNwlPfOA=";
  };

  npmDepsHash = "sha256-X13MOcV+qWj/YTVL8DfGmnJHgRXYcXTY7u3om/sI5N8=";

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
