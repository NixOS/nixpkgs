{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dufs";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-83lFnT4eRYaBe4e2o6l6AGQycm/oK96n5DXutBNvBsE=";
  };

  cargoHash = "sha256-WdjqG2URtloh5OnpBBnEWHD3WKGkCKLDcCyWRVGIXto=";

  nativeBuildInputs = [ installShellFiles ];

  __darwinAllowLocalNetworking = true;

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
