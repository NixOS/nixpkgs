{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "glooctl";
  version = "1.12.20";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-VQUet+KwVLltbISTnaUPElJBuTc0d2lKOA4yzhEn8tY=";
  };

  subPackages = [ "projects/gloo/cli/cmd" ];
  vendorSha256 = "sha256-584gGED37p5QycoquFwp3hNR9x70kB1EsO5aoZTEJ1Y=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/glooctl

    export HOME=$TMP
    installShellCompletion --cmd glooctl \
      --bash <($out/bin/glooctl completion bash) \
      --zsh <($out/bin/glooctl completion zsh)
  '';

  ldflags = [ "-s" "-w" "-X github.com/solo-io/gloo/pkg/version.Version=${version}" ];

  meta = with lib; {
    description = "glooctl is the unified CLI for Gloo";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nelsonjeppesen ];
  };
}
