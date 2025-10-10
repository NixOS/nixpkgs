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
  version = "1.19.5";

  src = fetchFromGitHub {
    owner = "knative";
    repo = "client";
    tag = "knative-v${finalAttrs.version}";
    hash = "sha256-CgKwZCdjNN27wP79vzzTkGdk56owUDBMN79rk/ckpaI=";
  };

  vendorHash = "sha256-MYIUOIdoYzHK7HBTdQzu7Jp17MYMJUnoK64jPEmIR+E=";

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
    maintainers = with lib.maintainers; [ bryanasdev000 ];
  };
})
