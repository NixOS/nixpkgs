{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
  version = "13.0.2";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
    hash = "sha256-xNSw4gG0KrnyCplDvZNJeHyg6CTWli7rEA4JzZCcvFo=";
  };

  vendorHash = "sha256-McdSiXpJHOURYvaiJXOcW03h/7SeBwDVx0EPbLAInvk=";

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
