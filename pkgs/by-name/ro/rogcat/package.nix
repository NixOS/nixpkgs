{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,

  pkg-config,
  libudev-zero,
}:

rustPlatform.buildRustPackage rec {
  pname = "rogcat";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "flxo";
    repo = "rogcat";
    rev = "refs/tags/v${version}";
    hash = "sha256-l2zfVt2vm5GTrYs6/0D3EesxxPWSmjf2tGS545766iA=";
  };

  cargoHash = "sha256-cDAS8mengFgBsq9nTiVAjt7pJhKjj7/F9x8IS6vP2ck=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libudev-zero
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Adb logcat wrapper";
    homepage = "https://github.com/flxo/rogcat";
    changelog = "https://github.com/flxo/rogcat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "rogcat";
    platforms = lib.platforms.linux;
  };
}
