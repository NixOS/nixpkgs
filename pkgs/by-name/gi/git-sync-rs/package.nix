{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  gitMinimal,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-sync-rs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = "git-sync-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J52a10KE7GrR4EZjZiKdOOOeSe2uJiCYmUz1nVqC+Ec=";
  };

  cargoHash = "sha256-xhoGROOCU0rZIUqitVqQtdTKlgyb0ieAvkyMRFTao8s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags = lib.optionals stdenv.isDarwin [
    # Integration test relies on Linux file watching semantics
    "--skip=continuous_changes_starve_debounce"
  ];

  postInstall = ''
    ln -s $out/bin/git-sync-rs $out/bin/git-sync-on-inotify
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Automatic git repository synchronization with file watching";
    homepage = "https://github.com/colonelpanic8/git-sync-rs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "git-sync-rs";
  };
})
