{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ember-cli";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "ember-cli";
    repo = "ember-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xkMsPE+iweIV14m4kE4ytEp4uHMJW6gr+n9oJblr4VQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-QgT2JFvMupJo+pJc13n2lmHMZkROJRJWoozCho3E6+c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/ember-cli/ember-cli";
    description = "Ember.js command line utility";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://github.com/ember-cli/ember-cli";
    description = "Ember.js command line utility";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ember";
  };
})
