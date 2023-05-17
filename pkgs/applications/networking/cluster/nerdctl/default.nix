{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, buildkit
, cni-plugins
, extraPackages ? [ ]
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1wqPMT8JJ29K0BcooPj7jaXMKIVlN6YvFwneYnqaeDk=";
  };

  vendorHash = "sha256-ix18Mi4a1kW7C6rcwwFc6TDwzs3vYxNz3M3d5pD8l6c=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  ldflags = let t = "github.com/containerd/nerdctl/pkg/version"; in
    [ "-s" "-w" "-X ${t}.Version=v${version}" "-X ${t}.Revision=<unknown>" ];

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

  meta = with lib; {
    homepage = "https://github.com/containerd/nerdctl/";
    changelog = "https://github.com/containerd/nerdctl/releases/tag/v${version}";
    description = "A Docker-compatible CLI for containerd";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk developer-guy ];
    platforms = platforms.linux;
  };
}
