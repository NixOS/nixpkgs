{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "korrect";
  version = "0.3.7";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-qpjpdP0KeuwF5XhnlkrKcXJ4puHNpt/7SrIFOnFjGNA=";
  };
  cargoHash = "sha256-1k2I8R5H4UGYf7rc9r2SwMwrA2F7PlECbsCco731beQ=";

  # Tests create a local http server to check the download functionality
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completions bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completions fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completions zsh) \
      --nushell <($out/bin/${finalAttrs.meta.mainProgram} completions nushell)
  '';

  meta = {
    description = "Kubectl version managing shim that invokes the correct kubectl version";
    homepage = "https://gitlab.com/cromulentbanana/korrect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwt ];
    mainProgram = "korrect";
  };
})
