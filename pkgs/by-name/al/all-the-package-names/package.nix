{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "all-the-package-names";
  version = "2.0.2129";

  src = fetchFromGitHub {
    owner = "nice-registry";
    repo = "all-the-package-names";
    tag = "v${version}";
    hash = "sha256-aq4WxaeMprw9ohcwd9HuiWq5GUpW6dI3FSudMyUo6Fg=";
  };

  npmDepsHash = "sha256-WM2FO/qsDcXaV/2oqBlRGXc+VHaPUxFVg1DF6F0iGso=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List of all the public package names on npm";
    homepage = "https://github.com/nice-registry/all-the-package-names";
    license = lib.licenses.mit;
    mainProgram = "all-the-package-names";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
