{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "kool";
  version = "3.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kool-dev";
    repo = "kool";
    tag = finalAttrs.version;
    hash = "sha256-YVwxJT97Roi1QaCJ2Kl6VfpxNasbqJ9FmWoY3PPq5aM=";
  };

  vendorHash = "sha256-tJxXtckglVk0U3UEBxk/g6mCtnPVcFf9/CkdLhn4bcI=";

  ldflags = [
    "-s"
    "-X=kool-dev/kool/commands.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "From local development to the cloud: development workflow made easy";
    mainProgram = "kool";
    homepage = "https://kool.dev";
    changelog = "https://github.com/kool-dev/kool/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
