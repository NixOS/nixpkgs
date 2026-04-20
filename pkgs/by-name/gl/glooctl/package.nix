{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "glooctl";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EURfI5fpT9aFKrUTB2x8JZAsk0HrxWNlSYK3m2ej4fw=";
  };

  vendorHash = "sha256-Gl4gIbGfNNl29mWwZGVcMQ80F7A4heEStFAMdW114Os=";

  subPackages = [ "projects/gloo/cli/cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  strictDeps = true;

  ldflags = [
    "-s"
    "-X github.com/solo-io/gloo/pkg/version.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/glooctl
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glooctl \
      --bash <($out/bin/glooctl completion bash) \
      --zsh <($out/bin/glooctl completion zsh)
  '';

  meta = {
    description = "Unified CLI for Gloo, the feature-rich, Kubernetes-native, next-generation API gateway built on Envoy";
    mainProgram = "glooctl";
    homepage = "https://docs.solo.io/gloo-edge/latest/reference/cli/glooctl/";
    changelog = "https://github.com/solo-io/gloo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
