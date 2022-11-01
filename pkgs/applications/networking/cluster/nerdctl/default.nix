{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, buildkit
, libselinux
, rootlesskit
, containerd
, runc # Default container runtime
, slirp4netns # User-mode networking for unprivileged namespaces
, util-linux # nsenter
, iptables
, iproute2
, cni-plugins
, extraPackages ? [ ]
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hSuBN+yuwXfGP7gNtYR37yl+n5hj2sp6hJ5d8tyXkf0=";
  };

  vendorSha256 = "sha256-2pYjN904pQoliBSaCysumkMocvZDxwsTvZxgDCacVrc=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  ldflags = let t = "github.com/containerd/nerdctl/pkg/version"; in
    [ "-s" "-w" "-X ${t}.Version=v${version}" "-X ${t}.Revision=<unknown>" ];

  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postInstall =
    let
      binPath =
        lib.makeBinPath ([
          libselinux
          rootlesskit
          containerd
          runc
          slirp4netns
          util-linux
          iptables
          iproute2
        ]);
    in
    ''
      wrapProgram $out/bin/nerdctl \
        --prefix PATH : "${lib.makeBinPath ([ buildkit runc ] ++ extraPackages)}" \
        --prefix CNI_PATH : "${cni-plugins}/bin"

      install -D extras/rootless/containerd-rootless.sh $out/bin/containerd-rootless

      wrapProgram $out/bin/containerd-rootless \
        --prefix PATH : ${lib.escapeShellArg binPath}

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
    maintainers = with maintainers; [ jk jlesquembre ];
    platforms = platforms.linux;
  };
}
