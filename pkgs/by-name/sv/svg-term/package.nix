{
  asciinema,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  makeWrapper,
  nodejs,
  stdenv,
  versionCheckHook,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svg-term";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "marionebl";
    repo = "svg-term-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sB4/SM48UmqaYKj6kzfjzITroL0l/QL4Gg5GSrQ+pdk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-4Q1NP3VhnACcrZ1XUFPtgSlk1Eh8Kp02rOgijoRJFcI=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Some things work without asciinema on the PATH, but --command does not.
  postInstall = ''
    wrapProgram $out/bin/svg-term --prefix PATH : ${lib.makeBinPath [ asciinema ]}
  '';

  meta = {
    description = "Share terminal sessions as razor-sharp animated SVG everywhere";
    homepage = "https://github.com/marionebl/svg-term-cli";
    license = lib.licenses.mit;
    mainProgram = "svg-term";
    maintainers = with lib.maintainers; [ samestep ];
  };
})
