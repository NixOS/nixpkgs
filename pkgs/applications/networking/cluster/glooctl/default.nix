{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "glooctl";
  version = "1.16.8";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-M8ZNDt+sO8ZtVM1PyISOsFwXrD6q9ACPG0T99bqwk1c=";
  };

  vendorHash = "sha256-UyzqKpF2WBj25Bm4MtkF6yjl87A61vGsteBNCjJV178=";

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
    mainProgram = "glooctl";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
