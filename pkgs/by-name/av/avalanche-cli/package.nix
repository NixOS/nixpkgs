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
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "avalanche-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bAZJRFlry7vYTTf95kTOJwcjYelN40n264oeykx7nxc=";
  };

  proxyVendor = true;
  vendorHash = "sha256-0+YwlCHjiU46y333RSuaha4pLKFTYlj+M9+TFAALamY=";

  # Fix error: 'Caught SIGILL in blst_cgo_init'
  # https://github.com/bnb-chain/bsc/issues/1521
  CGO_CFLAGS = "-O -D__BLST_PORTABLE__";
  CGO_CFLAGS_ALLOW = "-O -D__BLST_PORTABLE__";

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

  doCheck = false;

  meta = {
    description = "Command line tool that gives developers access to everything Avalanche";
    homepage = "https://github.com/ava-labs/avalanche-cli";
    changelog = "https://github.com/ava-labs/avalanche-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "avalanche";
  };
})
