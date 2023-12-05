{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "psalm";
  version = "5.16.0";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    rev = finalAttrs.version;
    hash = "sha256-0Tq/WeLM9it1uwvzSfVqd7FFRyrBXZCsswtYMXxan0w=";
  };

  # To remove if https://github.com/vimeo/psalm/issues/10446 gets fixed.
  composerLock = ./composer.lock;
  composerStrictValidation = false;
  vendorHash = "sha256-2CZDRZXgOw+3Kp6lsTik+iVtCitOdeRzoF6aucoYalA=";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "A static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})
