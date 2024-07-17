{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  buildkit,
  cni-plugins,
  extraPackages ? [ ],
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z83c8Ji0zSM1QDwjB4FwhHW6XCqG0Hb5crM3jjK46jk=";
  };

  vendorHash = "sha256-KqWmwwQRrWoyRehuSJBnlyPQgwk5hUGk2/d0Ue/reVc=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  ldflags =
    let
      t = "github.com/containerd/nerdctl/pkg/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=v${version}"
      "-X ${t}.Revision=<unknown>"
    ];

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
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nerdctl --help
    $out/bin/nerdctl --version | grep "nerdctl version ${version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${version}";
    description = "A Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      jk
    ];
    platforms = lib.platforms.linux;
  };
}
