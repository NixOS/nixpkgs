{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "glooctl";
  version = "1.19.6";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";
    hash = "sha256-jH/QnRGeuYv7e7QNGLvVhLwvX5kHtqArOUPYdXcKURw=";
  };

  vendorHash = "sha256-OJeWijGwxuBd0Qsscy7wjTkzglUZg+jHuPX1s1ayZVI=";

  subPackages = [ "projects/gloo/cli/cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  strictDeps = true;

  ldflags = [
    "-s"
    "-X github.com/solo-io/gloo/pkg/version.Version=${version}"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/glooctl
    installShellCompletion --cmd glooctl \
      --bash <($out/bin/glooctl completion bash) \
      --zsh <($out/bin/glooctl completion zsh)
  '';

  meta = {
    description = "Unified CLI for Gloo, the feature-rich, Kubernetes-native, next-generation API gateway built on Envoy";
    mainProgram = "glooctl";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    changelog = "https://github.com/solo-io/gloo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
