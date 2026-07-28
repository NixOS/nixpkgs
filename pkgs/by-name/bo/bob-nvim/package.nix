{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bob";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = "MordechaiHadad";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2TrmLN9VPjueRRL7kcnfH+eBpEdAOAKGP8N9KZE8bH0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-Akn0p8NBZV3M+pM91W01GIX9mF8nL7dt/kk0ufES8T0=";

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bob \
      --bash <($out/bin/bob complete bash) \
      --fish <($out/bin/bob complete fish) \
      --zsh <($out/bin/bob complete zsh) \
      --nushell <($out/bin/bob complete nushell)
  '';

  meta = {
    description = "Version manager for neovim";
    homepage = "https://github.com/MordechaiHadad/bob";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaasboteram ];
    mainProgram = "bob";
  };
})
