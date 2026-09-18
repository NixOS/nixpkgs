{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clipaste";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "hqhq1025";
    repo = "clipaste";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4I/37f2iEQA9oqEhcXAo4lwZKtZuCt5MaL4v4OYpdc0=";
  };

  cargoHash = "sha256-14EbKpzAUlnP+rzEWk3e8CYkAtw36exDfDFTK1HFsr8=";

  strictDeps = true;
  __structuredAttrs = true;

  checkFlags = [
    # Runs the generated bash script in a simulated remote environment
    # (PATH=/usr/bin:/bin:...).  In the Nix sandbox standard tools like `grep`
    # are not available at those paths — syntax check and content assertions
    # already cover correctness.
    "--skip"
    "ssh_setup::tests::remote_script_run_installs_into_empty_home"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screenshot clipboard paste fix for AI agents";
    homepage = "https://github.com/hqhq1025/clipaste";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "clipaste";
  };
})
