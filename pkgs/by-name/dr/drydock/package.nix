{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "drydock";
  version = "1.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yetidevworks";
    repo = "drydock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R0mFtrqIQ4aIa30YW8dwqGVYm2wyL5UyTDZwwCICeLg=";
  };

  cargoHash = "sha256-tpZx7bWk6NwuSqtPXCn0Iqdng3YhB9QXVmj4cibK/68=";

  nativeCheckInputs = [ git ];

  checkFlags = [
    # relies on fs watching and timeouts which are flaky in the Nix sandbox
    "--skip=watch::tests::a_real_edit_reaches_the_callback"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "drydock";
    description = "A live TUI dashboard for a fleet of git repos";
    longDescription = ''
      What's uncommitted, unpushed, and unreleased across every repo you own.

      A drydock is where vessels sit while work is done on them, before they go back out.
      If you keep dozens or hundreds of checkouts on disk and lose track of which ones
      still have work sitting in them, this tells you, in one screen, live.
    '';
    homepage = "https://github.com/yetidevworks/drydock";
    downloadPage = "https://yetidevworks.com/drydock";
    changelog = "https://github.com/yetidevworks/drydock/releases#release-v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "yetidevworks" finalAttrs.version;
      purlParts = {
        type = "github";
        namespace = "yetidevworks";
        name = "drydock";
        version = finalAttrs.version;
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
