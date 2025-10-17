{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation rec {
  pname = "svg-term";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "marionebl";
    repo = "svg-term-cli";
    tag = "v${version}";
    hash = "sha256-sB4/SM48UmqaYKj6kzfjzITroL0l/QL4Gg5GSrQ+pdk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-4Q1NP3VhnACcrZ1XUFPtgSlk1Eh8Kp02rOgijoRJFcI=";
  };

  nativeBuildInputs = [
    nodejs
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  meta = {
    description = "Share terminal sessions as razor-sharp animated SVG everywhere";
    homepage = "https://github.com/marionebl/svg-term-cli";
    license = lib.licenses.mit;
    mainProgram = "svg-term";
    maintainers = with lib.maintainers; [ samestep ];
    platforms = lib.platforms.all;
  };
}
