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
    rev = "refs/tags/v${finalAttrs.version}";
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

  meta = with lib; {
    homepage = "https://github.com/ember-cli/ember-cli";
    description = "The Ember.js command line utility";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
    mainProgram = "ember";
  };
})
