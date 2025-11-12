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
    tag = "v${finalAttrs.version}";
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
      t = "github.com/containerd/nerdctl/v${lib.versions.major finalAttrs.version}/pkg/version";
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

    # Background for this clarification: https://github.com/NixOS/nixpkgs/pull/354002#discussion_r2021031543
    platforms = [
      "x86_64-linux"
      "i686-linux"

      "aarch64-linux"
      "armv7l-linux"

      "loong64-linux" # Added in 2.1.0: https://github.com/containerd/nerdctl/pull/2533

      "powerpc64le-linux"
      "riscv64-linux"
      "s390x-linux"

      "x86_64-freebsd"
    ];
  };
})
