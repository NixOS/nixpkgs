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
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FRu1h6DT43rPaa9dcgz83w9K+xtzJgB4l/eTu+Fbb+c=";
  };

  vendorSha256 = "sha256-QFACe1/5MVbXKTknEyqjWclEQgJSZAJ/QljhLq/tWe4=";

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
      --bash <($out/bin/nerdctl completion bash)
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
    maintainers = with maintainers; [ jk ];
    platforms = platforms.linux;
  };
}
