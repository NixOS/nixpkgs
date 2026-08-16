{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nixosTests,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "artalk";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gtWnXRDGFjpw9W1ze6fBn/WXMQStqeyQpQHTr3wu5AU=";
  };

  vendorHash = "sha256-xSIkJKlWGbdBlez7jPaoeHuYbyO+2237sZ/yxjUcHf8=";

  ldflags = [
    "-s"
  ];

  preConfigure = ''
    cp -r ${finalAttrs.passthru.frontend}/* ./public
  '';

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  # TestAuthSSOExchange
  __darwinAllowLocalNetworking = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd artalk \
      --bash <($out/bin/artalk completion bash) \
      --fish <($out/bin/artalk completion fish) \
      --zsh <($out/bin/artalk completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "XDG_DATA_HOME" ];
  preVersionCheck = "XDG_DATA_HOME=$TMPDIR";

  passthru = {
    tests = {
      inherit (nixosTests) artalk;
    };
    frontend = callPackage ./frontend.nix { artalk = finalAttrs.finalPackage; };
    updateScript = nix-update-script { extraArgs = [ "--subpackage=frontend" ]; };
  };

  meta = {
    description = "Self-hosted comment system";
    homepage = "https://github.com/ArtalkJS/Artalk";
    changelog = "https://github.com/ArtalkJS/Artalk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "artalk";
  };
})
