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
<<<<<<< HEAD
  version = "0.3.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-AOYwknKVtvw/gQ10gwHTNFQ2KvPuldRk8UxRcbkO6tE=";
  };
  cargoHash = "sha256-2od1FlV7yx9bAV1eSvTVeJfm7FsGtFGTzsBPh6Of+SU=";
=======
  version = "0.3.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-iEbzYcWxDAumGLsr7MlqOrTEj3SwGFmdvw15M5Fz9cs=";
  };
  cargoHash = "sha256-RIa1rn74I/DQktjtY4BTWiYIBO1aLpXcKtXMBOAogvE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Tests create a local http server to check the download functionality
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completions bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completions fish) \
<<<<<<< HEAD
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completions zsh) \
      --nushell <($out/bin/${finalAttrs.meta.mainProgram} completions nushell)
=======
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completions zsh)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  meta = {
    description = "Kubectl version managing shim that invokes the correct kubectl version";
    homepage = "https://gitlab.com/cromulentbanana/korrect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwt ];
    mainProgram = "korrect";
  };
})
