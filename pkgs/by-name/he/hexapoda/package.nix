{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexapoda";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "simonomi";
    repo = "hexapoda";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZIZVioyo/1U7sy6rWLcuABRsHO6rU69keQpfH6tfcD0=";
  };

  cargoHash = "sha256-4MeStfLWv/M3rycdTULuqAli7bUQXQ0WDZvYHWpOd1A=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # Build.rs script checks if these exist to actually create the completions and manpage
  env = {
    HEXAPODA_COMPLETIONS = "completions";
    HEXAPODA_MANPAGE = "man";
  };

  preBuild = ''
    mkdir -p "$HEXAPODA_COMPLETIONS" "$HEXAPODA_MANPAGE"
  '';

  postInstall = ''
    installShellCompletion --bash completions/hexapoda.bash
    installShellCompletion --fish completions/hexapoda.fish
    installShellCompletion --zsh completions/_hexapoda
    installShellCompletion --nushell completions/hexapoda.nu

    installManPage man/hexapoda.1
  '';

  meta = {
    description = "A colorful modal hex editor";
    homepage = "https://simonomi.dev/hexapoda";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/simonomi/hexapoda/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "hexapoda";
  };
})
