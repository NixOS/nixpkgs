{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  valgrind,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-sVW3zNe0a9iQQ0vRWJofqG4gwUJ/w0U4ugVyMNtWX98=";
  };

  cargoHash = "sha256-sRJGnbQFCk+SJtG/hnde+8ggZuutrdk0279ziickmnA=";
=======
    sha256 = "sha256-fAZngB4Z5dd6j+CfX+Tc3NNZHGRCz1C+T7QYmUn96SM=";
  };

  cargoHash = "sha256-hcUZm2h7rtBiYl2JXlt/AuKfhf/5YpqTYYAWxq0dQ8U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    "--skip tests_are_runnable"
    "--skip default_cargo_project_reports_no_violations"
<<<<<<< HEAD
    "--skip empty_tests_not_leak_in_release_mode"
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
=======
  ];

  meta = with lib; {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    mainProgram = "cargo-valgrind";
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      otavio
      matthiasbeyer
    ];
  };
}
