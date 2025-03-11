{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "play";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "paololazzari";
    repo = "play";
    tag = "v${version}";
    hash = "sha256-31naTjYwCytytKXg9tQo2qx0hVoBwBwL7nVeoAV+/go=";
  };

  vendorHash = "sha256-9eP0rhsgpTttYrBG/BNk/ICtaM+zKNBz2H2cHuTSt30=";

  modRoot = ".";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI playground for programs like grep, sed and awk";
    homepage = "https://github.com/paololazzari/play";
    changelog = "https://github.com/paololazzari/play/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "play";
  };
}
