{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "jsdoc";
  version = "5.0.0-dev.19";

  src = fetchFromGitHub {
    owner = "jsdoc";
    repo = "jsdoc";
    tag = "jsdoc@${finalAttrs.version}";
    hash = "sha256-dd68veLr78YRw06o/KzlhHtmSznnu7XHK6gTu6V4sJU=";
  };

  npmWorkspace = "packages/jsdoc";

  npmDepsHash = "sha256-29xgiKNGwVNv+l3ou3RNamBNp0ykbDlUCsnlo0CEcSI=";

  dontNpmBuild = true;

  postBuild = ''
    npm run test
  '';

  postInstall = ''
    mkdir -p $out/lib/node_modules/jsdoc/packages
    mv packages/* $out/lib/node_modules/jsdoc/packages
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version=unstable"
      "--version-regex"
      "jsdoc@(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/jsdoc/jsdoc/releases/jsdoc@${finalAttrs.version}";
    description = "API documentation generator for JavaScript";
    homepage = "https://jsdoc.app";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
