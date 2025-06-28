{
  lib,
  blst,
  libusb1,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  makeWrapper,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "avalanche-cli";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanche-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LLGNeKlZVGztrgap8Ih6BMLlMCp7acAnxb7zcExixNA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-F2prsymg2ean7Er/tTYVUrdyOdtMhxk5/pyOJzONrr8=";

  ldflags = [
    "-s"
    "-X=github.com/ava-labs/avalanche-cli/cmd.Version=${finalAttrs.version}"
  ];

  buildInputs = [
    blst
    libusb1
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  patches = [ ./skip_min_version_check.patch ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/avalanche"
        else
          lib.getExe buildPackages.avalanche-cli;
    in
    ''
      mv $out/bin/avalanche-cli $out/bin/avalanche
      wrapProgram $out/bin/avalanche --add-flags "--skip-update-check"

      mkdir $HOME/.avalanche-cli
      echo "{ }" > $HOME/.avalanche-cli/config.json

      installShellCompletion --cmd avalanche \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/avalanche";
  versionCheckProgramArg = "--version";

  doCheck = false;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool that gives developers access to everything Avalanche";
    homepage = "https://github.com/ava-labs/avalanche-cli";
    changelog = "https://github.com/ava-labs/avalanche-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "avalanche";
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
})
