{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  go-mockery,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGo127Module (finalAttrs: {
  pname = "sesh";
  version = "2.29.0";
  __structuredAttrs = true;

  nativeBuildInputs = [
    (go-mockery.override { buildGoModule = buildGo127Module; })
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iP3D6wKqjFoWtKJ3Y9ndowvsvPfompBU+J0XQbnCeYE=";
  };

  # NOTE: prevent crash when getting vendor deps/hash
  overrideModAttrs = _: {
    preBuild = "";
  };

  preBuild = ''
    mockery
  '';

  vendorHash = "sha256-81PNc4Gt3wzGyihRWOtJFlIiA7HieZyGh/4gpFHVlYA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gwg313
      randomdude
      t-monaghan
    ];
    mainProgram = "sesh";
  };
})
