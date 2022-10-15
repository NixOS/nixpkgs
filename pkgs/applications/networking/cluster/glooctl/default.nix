{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "glooctl";
  version = "1.12.21";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-Hb33S6ADqyDnSo/rMEwIqm1dW3di5vo4wfPkEuMFybg=";
  };

  subPackages = [ "projects/gloo/cli/cmd" ];
  vendorSha256 = "sha256-D43Sax4GhdojTb3BHwDOHYp9kM3sjk3ZAvCNp5RoyoM=";

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
