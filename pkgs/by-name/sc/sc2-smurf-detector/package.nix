{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sc2-smurf-detector";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "git.kittycloud.eu";
    owner = "mizule";
    repo = "sc2-smurf-detector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9vpbnp+q5QAOn+EpuwXG4LfruB999v2SEvYLhfMg8II=";
  };

  cargoHash = "sha256-Wm4/KmuAz9lno9vAsSwVykL2kQNf88kE3+zao3keRWI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI tool to detect smurfs in StarCraft II by analyzing opponent match history via SC2 Pulse";
    homepage = "https://git.kittycloud.eu/mizule/sc2-smurf-detector";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ _0xMillyByte ];
    mainProgram = "sc2-smurf-detector";
  };
})
