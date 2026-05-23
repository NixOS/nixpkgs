{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexapoda";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "simonomi";
    repo = "hexapoda";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UL9y7ofI9VRGbmKG2tX2Ax/So1OhemznUFPR9LOA6Os=";
  };

  cargoHash = "sha256-pfzziyjlrMFM65+ZusqXpp+utVHHV0pWE2lCZwHYiBM=";

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
