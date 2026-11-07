{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "dbml-renderer";
  version = "1.0.31";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "softwaretechnik-berlin";
    repo = "dbml-renderer";
    tag = finalAttrs.version;
    hash = "sha256-2CRdC6IAmnF1s/NfngCJSIl+gtuXA4CfjsM+RBpOmc0=";
  };

  npmDepsHash = "sha256-Ha0HJTJNZ/+tfszpKkfjDathjxJn3+lTiIncZ97s6LA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to render DBML files to SVG images";
    homepage = "https://github.com/softwaretechnik-berlin/dbml-renderer";
    changelog = "https://github.com/softwaretechnik-berlin/dbml-renderer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dbml-renderer";
    platforms = lib.platforms.all;
  };
})
