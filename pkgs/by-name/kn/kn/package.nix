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
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    tag = "knative-v${finalAttrs.version}";
    hash = "sha256-/mQvYYMwOvrwrIt8xo3j5qXXmfwDFJByaj1quHc5ebk=";
  };

  vendorHash = "sha256-1CTzRMlMsF4AZHYZMq0klmNpfmk4/O6ToitHyA9eEg0=";

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
