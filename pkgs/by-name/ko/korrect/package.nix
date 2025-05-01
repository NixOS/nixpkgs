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
  version = "0.1.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-ONM9S9M02XEpB4k7M2aJsQOduzNvlXbAIiebCJzO1uo=";
  };
  cargoHash = "sha256-EAyLg1q1R8mXP6gG/TrpjYrwhp6TJrrrU6Dfmz7W0zA=";

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
    # kubectl downloads don't work on x86_64-darwin yet, still investigating with upstream
    # https://gitlab.com/cromulentbanana/korrect/-/issues/14
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
    maintainers = [ lib.maintainers.dwt ];
  };
})
