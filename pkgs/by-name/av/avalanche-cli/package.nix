{
  stdenv,
  buildPackages,
  fetchFromGitHub,
  lib,
  buildGoModule,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
  blst,
  libusb1,
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
    "-X=github.com/ava-labs/avalanche-cli/cmd.Version=${finalAttrs.version}"
  ];

  buildInputs = [
    blst
    libusb1
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    mv $out/bin/avalanche-cli $out/bin/avalanche

    ${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in
      ''
        installShellCompletion --cmd avalanche \
          --bash <(${emulator} $out/bin/avalanche completion bash) \
          --fish <(${emulator} $out/bin/avalanche completion fish) \
          --zsh <(${emulator} $out/bin/avalanche completion zsh)
      ''
    )}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/avalanche";
  versionCheckProgramArg = "--version";

  doCheck = false;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool that gives developers access to everything Avalanche";
    homepage = "https://github.com/ava-labs/avalanche-cli";
    changelog = "https://github.com/ava-labs/avalanche-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "avalanche";
  };
})
