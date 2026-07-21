{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "13.2.4";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-TL6KYumNXUQ2nvkw3s/0UtT3CVw1YZfAmaCn8FHznrg=";
  };

  vendorHash = "sha256-Vlpjra9pcqhEy6fe6he6gsivQEmaHRgspy14DwCEOW4=";

  passthru = {
    updateScript = nix-update-script { };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    mainProgram = "phpunit";
    maintainers = with lib.maintainers; [
      onny
      patka
    ];
  };
})
