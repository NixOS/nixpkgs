{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
}:

let
  pname = "ember-cli";
  version = "5.3.0";
  src = fetchFromGitHub {
    owner = "ember-cli";
    repo = "ember-cli";
    rev = "v${version}";
    hash = "sha256-xkMsPE+iweIV14m4kE4ytEp4uHMJW6gr+n9oJblr4VQ=";
  };
in
mkYarnPackage {
  inherit pname version src;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-QgT2JFvMupJo+pJc13n2lmHMZkROJRJWoozCho3E6+c=";
  };

  packageJSON = ./package.json;

  meta = with lib; {
    homepage = "https://github.com/ember-cli/ember-cli";
    description = "The Ember.js command line utility";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = platforms.all;
    mainProgram = "ember";
  };
}
