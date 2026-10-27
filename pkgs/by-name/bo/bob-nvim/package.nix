{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bob";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "MordechaiHadad";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fvMs4AWSpY33oxiBBCYWVIfTC/RNuDI57nnAO+awfEw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-jIZaGTqqqS4c9ZSKHqbl5ozbtlOVrmDWS+dT4veP9ww=";

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
