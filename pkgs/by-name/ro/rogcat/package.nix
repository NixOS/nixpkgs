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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "flxo";
    repo = "rogcat";
    rev = "refs/tags/v${version}";
    hash = "sha256-nXKvepuiBDIGo8Gga5tbbT/mnC6z+HipV5XYtlrURRU=";
  };

  cargoHash = "sha256-a+B9bMuKhmt3ka9p7a/O6JggiAxMzm9C5PdbFZD1KP0=";

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
