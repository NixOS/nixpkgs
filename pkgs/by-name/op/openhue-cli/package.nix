{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "openhue-cli";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "openhue";
    repo = "openhue-cli";
    tag = finalAttrs.version;
    hash = "sha256-u6ulk+qv1FlZ7PdUiO9UXtRqWWp2MMRAnc8F9vHnRBo=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-3930OjQ26n7J3XDWjCthfQjORP5wpJ3ZZK/m6/wi2X4=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
  '';

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
