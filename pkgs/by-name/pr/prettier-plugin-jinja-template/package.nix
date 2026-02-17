{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "prettier-plugin-jinja-template";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "davidodenwald";
    repo = "prettier-plugin-jinja-template";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qAmN4VJCJana7YbrQC/51JKCbP2DN10HpIt+S88yvPE=";
  };

  npmDepsHash = "sha256-/m0+z2fSwX77zRY4Yg4xdyI/ZEzAKNUuicaqz0b8f5w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter plugin for Jinja2 template files";
    homepage = "https://github.com/davidodenwald/prettier-plugin-jinja-template";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koi ];
    mainProgram = "prettier-plugin-jinja-template";
  };
})
