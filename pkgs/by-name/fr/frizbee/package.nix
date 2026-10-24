{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,

  installShellFiles,

  buildPackages,

  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "frizbee";
  version = "0.1.11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "frizbee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QmPzM7xdOuDt1d4jzqrDcHr3oqh8BbmFKBBbovVE/TA=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-MdRSl4eCFCFzkT1A7AWULUDveWC9hj2kP1JqTUraYe4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
    "-X=main.TreeState=clean"
    "-X=github.com/stacklok/frizbee/internal/cli.CLIVersion=${finalAttrs.version}"
  ];

  preBuild = ''
    ldflags+=" -X main.Commit=$(cat COMMIT)"
    ldflags+=" -X main.CommitDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  # almost all functionality requires the internet
  doCheck = false;

  postInstall =
    let
      cmd = finalAttrs.meta.mainProgram;
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/${cmd}"
        else
          lib.getExe buildPackages.frizbee;
    in
    ''
      installShellCompletion --cmd ${cmd} \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Throw a tag at it and it comes back with a checksum";
    homepage = "https://github.com/stacklok/frizbee";
    changelog = "https://github.com/stacklok/frizbee/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "frizbee";
  };
})
