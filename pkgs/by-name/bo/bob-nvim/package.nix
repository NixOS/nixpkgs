{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bob";
  version = "4.1.6";

  src = fetchFromGitHub {
    owner = "MordechaiHadad";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XI/oNGKLXQ/fpB6MojhTsEgmmPH1pHECD5oZgc1r4rQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-YSZcYTGnMnN/srh8Z15toq+GIyRKfFd+pGkFQl5gCuo=";

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
