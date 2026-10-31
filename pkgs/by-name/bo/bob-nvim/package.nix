{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bob";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "MordechaiHadad";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UvKVbFwqiPr2plFRUxpnSH8b8u5ku8F2r5urw/JQty0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-W7IJu1PX4+g1qLL6MaPfJyoNdVdzTsYkSV5fGZNJoMk=";

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
