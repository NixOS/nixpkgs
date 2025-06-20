{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdlfmt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qc2wU/borl3h2fop6Sav0zCrg8WdvHrB3uMA72uwPis=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xoOnFJqDucg3fUDx5XbXsZT4rSjZhzt5rNbH+DZ1kGA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kdlfmt \
      --bash <($out/bin/kdlfmt completions bash) \
      --fish <($out/bin/kdlfmt completions fish) \
      --zsh <($out/bin/kdlfmt completions zsh)
  '';

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
})
