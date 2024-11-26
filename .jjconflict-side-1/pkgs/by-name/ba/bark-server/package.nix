{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "bark-server";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Finb";
    repo = "bark-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-lPhRWMR+gConFOxiSONBRrwPoARaGqzaIU3hd3wSO8E=";
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

  vendorHash = "sha256-GemXcU5nmMkZSNpuXoRt9EH5PrxMHWLJ56bNYHXOB9I=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  preBuild = ''
    ldflags+=" -X \"main.buildDate=$(cat SOURCE_DATE_EPOCH)\""
    ldflags+=" -X main.commitID==$(cat COMMIT)"
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Backend of Bark, an iOS App which allows you to push customed notifications to your iPhone";
    homepage = "https://github.com/Finb/bark-server";
    changelog = "https://github.com/Finb/bark-server/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "bark-server";
  };
}
