{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "sesh";
  version = "2.20.0";

  nativeBuildInputs = [
    go-mockery
  ];
  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YfgxXM8FPRAUk4jxUnQNNB8hMjiB5ZCRY2/S+OgzECs=";
  };

  preBuild = ''
    mockery
  '';
  vendorHash = "sha256-GEWtbhZhgussFzfg1wNEU0Gr5zhXmwlsgH6d1cXOwvc=";

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
