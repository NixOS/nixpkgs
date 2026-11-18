{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "openhue-cli";
  version = "0.25";

  src = fetchFromGitHub {
    owner = "openhue";
    repo = "openhue-cli";
    tag = finalAttrs.version;
    hash = "sha256-2Bp07/FJZlAgeIxLjhlGunq+5/GCXWG1QuK/1J+2uCE=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-3nKSlJ+EiAiW/UhHRminZ0QIqMqKv7UBjsNBBR8uY1M=";

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
