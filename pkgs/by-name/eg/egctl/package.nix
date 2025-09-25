{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "egctl";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-glOnAnNuefdTq4BOd1NKpsadrWEqVOOc18jPx7lEwEQ=";
  };

  vendorHash =
    if stdenv.buildPlatform.isDarwin then
      "sha256-GoaucckTuJIvaq1/3R1rPDr3Nm8q27OICisomKXYJ28="
    else
      "sha256-+RTnsUg2LNSQ6pB99ikAKxd3q6IRhp2LHdBznYrHm4o=";

  subPackages = [
    "cmd/egctl"
    "internal/cmd/egctl"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/envoyproxy/gateway/internal/cmd/version.envoyGatewayVersion=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/egctl completion bash >egctl.bash
    $out/bin/egctl completion fish >egctl.fish
    $out/bin/egctl completion zsh >egctl.zsh
    installShellCompletion egctl.{bash,fish,zsh}
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "egctl version --remote=false";
      version = "v${finalAttrs.version}";
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line utility for operating Envoy Gateway";
    homepage = "https://gateway.envoyproxy.io";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.maxbrunet ];
    mainProgram = "egctl";
  };
})
