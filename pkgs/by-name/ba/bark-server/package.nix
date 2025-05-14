{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bark-server";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Finb";
    repo = "bark-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c3kMGD4JuLAP/Ms2dJBAl85urvranGGIicTmx4gIhNM=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-Yti+W3GKUMEfNBHf4C435BpYsDjCzgfLr55iqU3BGbA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X \"main.buildDate=$(<SOURCE_DATE_EPOCH)\""
    ldflags+=" -X main.commitID==$(<COMMIT)"
  '';

  # All tests require network
  doCheck = false;

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Backend of Bark, an iOS App which allows you to push customed notifications to your iPhone";
    homepage = "https://github.com/Finb/bark-server";
    changelog = "https://github.com/Finb/bark-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "bark-server";
  };
})
