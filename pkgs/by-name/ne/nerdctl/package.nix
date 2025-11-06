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
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "nerdctl";
    rev = "v${version}";
    hash = "sha256-GHFs8QvLcXu+DZ851TCLI7EVc9wMS5fRC4TYBXzyv3Q=";
  };

  vendorHash = "sha256-5LRsT04T/CKv+YHaiM2g6giimWWXyzPju3iZuj2DfAY=";

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
    description = "Docker-compatible CLI for containerd";
    mainProgram = "nerdctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      jk
    ];
    platforms = lib.platforms.linux;
    knownVulnerabilities = [
      "CVEs in the dependency of this version have been fixed in nerdctl version 2.2.0."
      "CVE-2024-25621"
      "CVE-2025-64329"
      "CVE-2025-31133"
      "CVE-2025-52565"
      "CVE-2025-52881"
    ];
  };
}
