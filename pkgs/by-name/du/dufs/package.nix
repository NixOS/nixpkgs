{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  stdenv,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dufs";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wGRu0E4uAlNtBIZ7C9O0S9VAjQjdn2M0/KV8mqgQWDU=";
  };

  cargoHash = "sha256-DFJjJ8e3EdNC+4AcSXwNPOvJ6rbb7wZR44gmyZzDI2o=";

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

  passthru.tests = { inherit (nixosTests) dufs; };

  meta = {
    description = "File server that supports static serving, uploading, searching, accessing control, webdav";
    mainProgram = "dufs";
    homepage = "https://github.com/sigoden/dufs";
    changelog = "https://github.com/sigoden/dufs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      font44
      holymonson
    ];
  };
})
