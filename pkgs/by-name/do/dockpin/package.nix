{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dockpin";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Jille";
    repo = "dockpin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6KwVypt9PGI6508XOCbhNtpTVOBi2kdhLlyxxjkzi9Q=";
  };

  vendorHash = "sha256-HdZO/o49Gbu0M+W2U/265slzvVFTl1iu+m6BKMe/CcQ=";

  ldflags = [ "-s" ];

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail 'Version: "dev"' 'Version: "${finalAttrs.version}"'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dockpin \
      --bash <($out/bin/dockpin completion bash) \
      --fish <($out/bin/dockpin completion fish) \
      --zsh <($out/bin/dockpin completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for pinning Docker image and apt package versions";
    homepage = "https://github.com/Jille/dockpin";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dockpin";
  };
})
