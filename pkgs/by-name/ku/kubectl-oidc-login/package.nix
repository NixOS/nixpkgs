{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-oidc-login";
  version = "1.35.2";

  src = fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jSPNvr+spZvilTooK7s6l8CyvP5tzSWxqJzaoJCA5AM=";
  };

  vendorHash = "sha256-otzcOmW3mkiJrIv69wme5cHp5/iO2YSH+ecZgeX2aV0=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  # Rename output binary to kubectl-<plugin-name> so kubectl recognizes it on $PATH.
  postInstall = ''
    mv $out/bin/{kubelogin,${finalAttrs.meta.mainProgram}}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes kubelogin plugin to add OpenID Connect authentication to kubectl. Run \"kubectl oidc-login ...\"";
    # Quirk: we have to write "oidc_login" instead of "oidc-login"
    # (at least on Mac "aarch64-darwin" and "x86_64_linux"), otherwise calling
    # "kubectl oidc-login <subcommand>" fails that it can't find the underlying plugin in $PATH.
    mainProgram = "kubectl-oidc_login";
    homepage = "https://github.com/int128/kubelogin";
    changelog = "https://github.com/int128/kubelogin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malteneuss ];
  };
})
