{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dufs";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Be7aJ5Bo5JSMcyyWsZ3ZamQ691TSIO4Ylxzil7UNJxk=";
  };

  cargoHash = "sha256-H2ew+sb60UnXe3Dls9MSKwAk4hT/yLSbgZz6pVOkHQQ=";

  nativeBuildInputs = [ installShellFiles ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  checkFlags = [
    # tests depend on network interface, may fail with virtual IPs.
    "--skip=validate_printed_urls"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dufs \
      --bash <($out/bin/dufs --completions bash) \
      --fish <($out/bin/dufs --completions fish) \
      --zsh <($out/bin/dufs --completions zsh)
  '';

  meta = {
    description = "File server that supports static serving, uploading, searching, accessing control, webdav";
    mainProgram = "dufs";
    homepage = "https://github.com/sigoden/dufs";
    changelog = "https://github.com/sigoden/dufs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      holymonson
    ];
  };
})
