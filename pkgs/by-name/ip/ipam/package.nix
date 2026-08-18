{
  lib,
  stdenv,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ipam";
  version = "0.3.0-1";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "lauralani";
    repo = "ipam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gOkBjXgaMMWFRXFTSBY9YaNPdMRyLl8wy7BT/5vHio=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-l8eeeYv41yUPQ1dyJY4Jo3uvULrc1B/buGlMxYSdhCA=";

  ldflags = [
    "-s"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ipam \
      --bash <($out/bin/ipam completion bash) \
      --fish <($out/bin/ipam completion fish) \
      --zsh <($out/bin/ipam completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Cli based IPAM written in Go with PowerDNS support";
    homepage = "https://ipam.lauka.net/";
    changelog = "https://codeberg.org/lauralani/ipam/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "ipam";
  };
})
