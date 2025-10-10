{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  xz,
  go,
}:
buildGoModule (finalAttrs: {
  pname = "mender-cli";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "mendersoftware";
    repo = "mender-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-Pf87wTHXcFlnYsgx7ieiIJ9PWJFPUkFJYTkKJKmMFEQ=";
  };

  vendorHash = "sha256-MqyBa+wsbuXqtM4DL/QGBUWuEYlG8BRxIXq7O1LJUyM=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    xz
  ];

  allowGoReference = true;

  postFixup = ''
    wrapProgram "$out/bin/mender-cli" \
      --prefix PATH : ${go}/bin
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mender-cli \
      --bash <($out/bin/mender-cli completion bash) \
      --fish <($out/bin/mender-cli completion fish) \
      --zsh <($out/bin/mender-cli completion zsh) \
  '';

  meta = {
    description = "General-purpose CLI for the Mender backend";
    mainProgram = "mender-cli";
    homepage = "https://github.com/mendersoftware/mender-cli/";
    changelog = "https://github.com/mendersoftware/mender-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sagehefring ];
  };
})
