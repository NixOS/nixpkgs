{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "glooctl";
  version = "1.22.7";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CUGIU6e+gMpLvypDzIcj4iRPJXUIyZfIhe3wD8Fpn8k=";
  };

  vendorHash = "sha256-1HqINORSsOggB+spGR3cZZbYkeup9ntGHHhDYyBnuik=";

  subPackages = [ "projects/gloo/cli/cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X github.com/solo-io/gloo/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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
