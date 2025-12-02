{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarn,
  yarnBuildHook,
  yarnConfigHook,
  nixosTests,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "engelsystem";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "engelsystem";
    repo = "engelsystem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pi+nowImUvENx2c4gsku1KkFb3pLM84oT8WevI6ImQg=";
  };

  inherit php;

  vendorHash = "sha256-ODJgsvECw+q3sAA6pWNw4X2Png7f4G2Jty9AQSj/SgE=";
  composoerNoDev = true;
  composerStrictValidation = false;

  yarnOfflineCache = fetchYarnDeps {
    pname = "${finalAttrs.pname}-yarn-deps";
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-nyCLM9OF2qwlW+VK38kiRMo6jMlupNFG+91N3Fb/WLY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    yarn
    yarnConfigHook
  ];

  preBuild = ''
    yarn build
  '';

  preInstall = ''
    rm -rf node_modules

    # link config and storage into FHS locations
    ln -sf /etc/engelsystem/config.php ./config/config.php
    rm -rf storage
    ln -snf /var/lib/engelsystem/storage/ ./storage
  '';

  postInstall = ''
    mkdir $out/bin
    ln -s $out/share/php/engelsystem/bin/migrate $out/bin/migrate
  '';

  passthru.tests = nixosTests.engelsystem;

  meta = {
    changelog = "https://github.com/engelsystem/engelsystem/releases/tag/v${finalAttrs.version}";
    description = "Coordinate your volunteers in teams, assign them to work shifts or let them decide for themselves when and where they want to help with what";
    homepage = "https://engelsystem.de";
    license = lib.licenses.gpl2Only;
    mainProgram = "migrate";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
