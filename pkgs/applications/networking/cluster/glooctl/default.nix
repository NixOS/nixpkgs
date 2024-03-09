{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "glooctl";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-pxF5X3fCBeWFLQj8S0xYDcQNRs375RJIrl62nGjZZr0=";
  };

  vendorHash = "sha256-kbbgEnpqev7b4Sycmhs8xbu+yO4oMELh9xDmw7YyWYU=";

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
