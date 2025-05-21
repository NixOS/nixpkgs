{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gocatcli";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = "gocatcli";
    tag = "v${version}";
    hash = "sha256-qB7BDPDGcngPhd82V4FrsycFd7CNb6hPaHJQ+ECmo48=";
  };

  vendorHash = "sha256-gJfqnxCTKXmTH8L4qjSXzTr+LsP+jzzivfQOplRkfao=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gocatcli \
      --bash <($out/bin/gocatcli completion bash) \
      --fish <($out/bin/gocatcli completion fish) \
      --zsh <($out/bin/gocatcli completion zsh)
  '';

  nativeCheckInputs = [ versionCheckHook ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/deadc0de6/gocatcli";
    changelog = "https://github.com/deadc0de6/gocatcli/releases/tag/v${version}";
    description = "The command line catalog tool for your offline data";
    longDescription = ''
      gocatcli is a catalog tool for your offline data. It indexes external
      media in a catalog file and allows to quickly find specific files or even
      navigate in the catalog as if it was a mounted drive
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nadir-ishiguro
    ];
    mainProgram = "gocatcli";
  };
}
