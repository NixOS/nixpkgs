{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "openhue-cli";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "openhue";
    repo = "openhue-cli";
    tag = finalAttrs.version;
    hash = "sha256-yIPqjKIvYk2Y9BYieqrm5QvvAHnuImXEDbI1JOy0kBA=";
  };

  vendorHash = "sha256-lqIzmtFtkfrJSrpic79Is0yGpnLUysPQLn2lp/Mh+u4=";

  env.CGO_ENABLED = 0;

  rev = "c37f2a910173d8c9df42b40bd6efb583307a40cc";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.rev}"
  ];

  postInstall = ''
    mv $out/bin/openhue-cli $out/bin/openhue
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/openhue";
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    changelog = "https://github.com/openhue/openhue-cli/releases/tag/${finalAttrs.version}";
    description = "CLI for interacting with Philips Hue smart lighting systems";
    homepage = "https://github.com/openhue/openhue-cli";
    mainProgram = "openhue";
    maintainers = with lib.maintainers; [ madeddie ];
    license = lib.licenses.asl20;
  };
})
