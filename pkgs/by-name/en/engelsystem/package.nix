{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarn,
  yarnConfigHook,
  nixosTests,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "engelsystem";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "engelsystem";
    repo = "engelsystem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3Ejj/Hcxfd394sOlLy0Xk/CjKbJnTyUPQn5mNLH31I=";
  };

  inherit php;

  composerNoDev = true;
  composerStrictValidation = false;
  vendorHash = "sha256-Q1Vr8AywDAI6Apb4ShyV6DhSV3Fm0rX6X0uXlnO3CZo=";

  yarnOfflineCache = fetchYarnDeps {
    pname = "${finalAttrs.pname}-yarn-deps";
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-FRwmsnRsTVphSFurgaLcfNlNvxcC8fTR79G8r6RGB5A=";
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
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.all;
  };
})
