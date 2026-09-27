{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  writableTmpDirAsHomeHook,
  viceroy,
}:

buildGoModule (finalAttrs: {
  pname = "fastly";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xGp5Fa4ruHpc2YAAbrva0zurt4wxC6XRdSpMMQGEB7c=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  subPackages = [ "cmd/fastly" ];

  vendorHash = "sha256-JUYBaiAz91jv8QFrfjpHnY442+qK7T0VZJcC/rCGhD4=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  preBuild = ''
    ldflags+=" -X github.com/fastly/cli/pkg/revision.GitCommit=$(cat COMMIT)"
  '';

  ldflags = [
    "-s"
    "-X github.com/fastly/cli/pkg/revision.AppVersion=v${finalAttrs.version}"
    "-X github.com/fastly/cli/pkg/revision.Environment=release"
  ];

  # must embed viceroy to prevent fetching binary release on `fastly compute serve` invocation
  preFixup = ''
    wrapProgram $out/bin/fastly \
      --prefix PATH : ${lib.makeBinPath [ viceroy ]} \
      --set FASTLY_VICEROY_USE_PATH 1
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fastly \
      --bash <($out/bin/fastly --completion-script-bash) \
      --zsh <($out/bin/fastly --completion-script-zsh)
  '';

  meta = {
    description = "Command line tool for interacting with the Fastly API";
    homepage = "https://github.com/fastly/cli";
    changelog = "https://github.com/fastly/cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
      stepbrobd
    ];
    mainProgram = "fastly";
  };
})
