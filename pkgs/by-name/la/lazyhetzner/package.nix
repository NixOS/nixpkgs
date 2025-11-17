{
  lib,
  buildGoModule,
  fetchFromGitHub,

  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "lazyhetzner";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "grammeaway";
    repo = "lazyhetzner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hk1ZJ1DMotPVoR77dMb9deVbO/YUjORC+KVYBRIuLH0=";

    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-g+HWDhMNrPUsszmosClthEHS60Cp7zjt+50Jt9zqfTE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grammeaway/lazyhetzner/cmd.version=v${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X github.com/grammeaway/lazyhetzner/cmd.commit=$(cat COMMIT)"
    ldflags+=" -X github.com/grammeaway/lazyhetzner/cmd.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for managing Hetzner Cloud resources";
    homepage = "https://github.com/grammeaway/lazyhetzner";
    changelog = "https://github.com/grammeaway/lazyhetzner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "lazyhetzner";
  };
})
