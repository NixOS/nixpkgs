{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  valgrind,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-valgrind";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    tag = finalAttrs.version;
    sha256 = "sha256-ImZ0EHg/guPfx3vOfdi1nPz0MG0+61iZCFiVhNglZbs=";
  };

  cargoHash = "sha256-tH1RF3Uw9KkykgbPtXNY88uTvQ0f++aCP95Sd6Zexc8=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    makeWrapper
    valgrind # for tests where the executable is not wrapped yet
  ];

  postInstall = ''
    wrapProgram $out/bin/cargo-valgrind --prefix PATH : ${lib.makeBinPath [ valgrind ]}
  '';

  checkFlags = [
    "--skip=tests_are_runnable"
    "--skip=default_cargo_project_reports_no_violations"
    "--skip=empty_tests_not_leak_in_release_mode"
  ];

  meta = {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    mainProgram = "cargo-valgrind";
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      otavio
      matthiasbeyer
      chrjabs
    ];
  };
})
