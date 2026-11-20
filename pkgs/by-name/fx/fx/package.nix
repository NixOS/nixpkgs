{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "fx";
  version = "40.0.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "fx";
    tag = finalAttrs.version;
    hash = "sha256-LsT3B/EJ3Ejp4Ix+AzIRMYJXD480aehZmOwK8HFWjPM=";
  };

  vendorHash = "sha256-SUT3vYYzy8/O4PeUvzXxshaCgeETJ642ICiCJAVcHJ4=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fx \
      --bash <($out/bin/fx --comp bash) \
      --fish <($out/bin/fx --comp fish) \
      --zsh <($out/bin/fx --comp zsh)
  '';

  checkFlags = lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
    # flaky only on x86_64 darwin, https://hydra.nixos.org/build/319903711
    "-skip=^TestSearchCaching"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    changelog = "https://github.com/antonmedv/fx/releases/tag/${finalAttrs.src.tag}";
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    license = lib.licenses.mit;
    mainProgram = "fx";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
