{
  lib,
  fetchCrate,
  rustPlatform,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "korrect";
  version = "0.1.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-U363YI1CQg7KAUtzN2GPm4fNnD3TgJy+6hT/3JZ8e2s=";
  };
  cargoHash = "sha256-WP03Gv+Nai834xurVzdzV4uLA8fT/lbdu4zGWUgDKJo=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ${finalAttrs.pname} \
      --bash <($out/bin/${finalAttrs.pname} completions bash) \
      --fish <($out/bin/${finalAttrs.pname} completions fish) \
      --zsh <($out/bin/${finalAttrs.pname} completions zsh)
  '';

  meta = {
    description = "Kubectl version managing shim that invokes the correct kubectl version";
    homepage = "https://gitlab.com/cromulentbanana/korrect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwt ];
  };
})
