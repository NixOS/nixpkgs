{
  lib,
  fetchFromGitHub,
  nix-update-script,
  php,
<<<<<<< HEAD
=======
  phpunit,
  testers,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpunit";
<<<<<<< HEAD
  version = "12.5.4";
=======
  version = "12.4.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-asHHNHUBt4EO/vLQdc5JyffgUqgOeJSXSG+b5bL0IQk=";
  };

  vendorHash = "sha256-ypZLrCNNh/QUa5cvA6zuh3b/eyE0YMH0Diiet7cDveI=";

  passthru = {
    updateScript = nix-update-script { };
=======
    hash = "sha256-J57kK1wtiNJ54pAwnQNxvqdmA/omVyZKrnRJSeNX0Tg=";
  };

  vendorHash = "sha256-xaOM6BHaW4aEm5tAv3zFRg4QpV8L3p8y7KoipWtnqKI=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = phpunit; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
