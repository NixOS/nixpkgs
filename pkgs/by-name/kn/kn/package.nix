{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  getent,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kn";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    tag = "knative-v${finalAttrs.version}";
    hash = "sha256-G5kadNskSwKBxSuvs58aJUM7+lraevk2GKH/sncslTo=";
  };

  vendorHash = "sha256-+IiDWoT9E4SCkmOwPQMTM7AdrXVA6OJa0Fg9Xjq42gI=";

  env.GOWORK = "off";

  subPackages = [ "cmd/kn" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X knative.dev/client/pkg/commands/version.Version=v${finalAttrs.version}" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kn \
      --bash <($out/bin/kn completion bash) \
      --zsh <($out/bin/kn completion zsh)
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    PATH=$PATH:${getent}/bin $out/bin/kn version | grep ${finalAttrs.version} > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Create Knative resources interactively from the command line or from within scripts";
    mainProgram = "kn";
    homepage = "https://github.com/knative/client";
    changelog = "https://github.com/knative/client/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
