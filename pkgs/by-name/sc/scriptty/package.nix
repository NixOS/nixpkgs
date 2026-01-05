{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scriptty";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "justpresident";
    repo = "scriptty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ZjQT0XUoyc1Q2ZOI8hxnNABgFH+W79EF6JHYZ5k6Ko=";
  };

  cargoHash = "sha256-4ie8e9R4RcVOxEpPyhT/WYUnd0UUK9D5lWGIMuKslCA=";

  # Tests require a TTY to run
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Terminal Proxy Demo Engine";
    homepage = "https://github.com/justpresident/scriptty";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "scriptty";
  };
})
