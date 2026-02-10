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
  version = "0.3.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-2NzfMCMIIZM9/Z7MM8cenqtNCZsbivrjhBFlBQSgV8s=";
  };
  cargoHash = "sha256-Xjbc/QpcL6U8z+YwK5UjLRkHThqTIccjQc86nlOMEqE=";

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
