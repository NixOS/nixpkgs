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
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "engelsystem";
    repo = "engelsystem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hnTkeSqxkvO2Prop0VaBAV/4opr46wjEaJ5ptd5zQ34=";
  };

  inherit php;

  composerNoDev = true;
  composerStrictValidation = false;
  vendorHash = "sha256-oGpgtkX0UVSdVceQ8pD3PuGBITifQzaMIb4QRdc7WeY=";

  yarnOfflineCache = fetchYarnDeps {
    pname = "${finalAttrs.pname}-yarn-deps";
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-IMg1AoqCiQEvMHeqXgonIY2J0nmBHLW2Drz/Vb0rD48=";
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
