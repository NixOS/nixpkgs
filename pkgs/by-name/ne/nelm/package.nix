{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "nelm";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "werf";
    repo = "nelm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PDWx/J6OmF5/daZr5c66CD3uMjS8GL3U1dRwMlXjS5Y=";
  };

  vendorHash = "sha256-+57gKrXOzlKH5VRdZyKxOyg90aSKowPO9JPHVN92/GA=";

  subPackages = [ "cmd/nelm" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/nelm/pkg/common.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    # Test all packages.
    unset subPackages
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      for shell in bash fish zsh; do
        installShellCompletion \
          --cmd nelm \
          --$shell <(${emulator} $out/bin/nelm completion $shell)
      done
    ''
  );

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Kubernetes deployment tool, alternative to Helm 3";
    longDescription = ''
      Nelm is a Helm 3 alternative. It is a Kubernetes deployment tool that
      manages Helm Charts and deploys them to Kubernetes.
    '';
    homepage = "https://github.com/werf/nelm";
    changelog = "https://github.com/werf/nelm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "nelm";
  };
})
