{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "glooctl";
  version = "1.15.14";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-rQZOGM97mXKFFMQRw6+iiaDLugu0CM7OW2V7w0fgpDM=";
  };

  vendorHash = "sha256-51s+C4P8xKp52qjr6LK3zWKWzwnuEQyKxi/Wzpha9Fs=";

  subPackages = [ "projects/gloo/cli/cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  strictDeps = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/solo-io/gloo/pkg/version.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/glooctl
    installShellCompletion --cmd glooctl \
      --bash <($out/bin/glooctl completion bash) \
      --zsh <($out/bin/glooctl completion zsh)
  '';

  meta = {
    description = "glooctl is the unified CLI for Gloo";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
