{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit,
  cni-plugins,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  extraPackages ? [ ],
}:

buildGoModule (finalAttrs: {
  pname = "nerdctl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M3np4NfzEfMt4ii7Fdbdt+y1K7lSTWrqA9Bl+zpzxog=";
  };

  vendorHash = "sha256-cnusyughQitdvYhHtuvCGS9/LdI/ku7DETBdAWttKsY=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles

    # Workaround for: "FATA[0000] mkdir /homeless-shelter: permission denied" when building completions
    writableTmpDirAsHomeHook
  ];

  ldflags =
    let
      t = "github.com/containerd/nerdctl/v2/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=v${finalAttrs.version}"
      "-X ${t}.Revision=<unknown>"
    ];

  subPackages = [ "cmd/nerdctl" ];

  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${lib.makeBinPath ([ buildkit ] ++ extraPackages)}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"

    installShellCompletion --cmd nerdctl \
      --bash <($out/bin/nerdctl completion bash) \
      --fish <($out/bin/nerdctl completion fish) \
      --zsh <($out/bin/nerdctl completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nerdctl --help
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${finalAttrs.version}";
    description = "Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      jk
    ];
    platforms = lib.platforms.linux;
  };
})
