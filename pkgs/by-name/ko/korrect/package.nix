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
  version = "0.2.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-/tFrHTZ6YHnN9OvoHBJWEnwX780DYrs0f5wV1dPyAcc=";
  };
  cargoHash = "sha256-bG31pqI/eB+J0FUq/lWak6Ekf+00JiCfuKZdyUkIAAw=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completions bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completions fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completions zsh)
  '';

  meta = {
    description = "Kubectl version managing shim that invokes the correct kubectl version";
    homepage = "https://gitlab.com/cromulentbanana/korrect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwt ];
    mainProgram = "korrect";
  };
})
