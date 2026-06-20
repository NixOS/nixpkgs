{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "prettier-plugin-jinja-template";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "davidodenwald";
    repo = "prettier-plugin-jinja-template";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OBpY8XYG6Hn2sQpWoJkNJGsnZ1Lh7LAviofgCRFMXwk=";
  };

  npmDepsHash = "sha256-YsrDWoaA5EdQi3uzuWBx3Jv1US0qWwkh+636dfvlAkI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter plugin for Jinja2 template files";
    homepage = "https://github.com/davidodenwald/prettier-plugin-jinja-template";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koi ];
    mainProgram = "prettier-plugin-jinja-template";
  };
})
