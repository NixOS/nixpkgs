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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    tag = version;
    sha256 = "sha256-oLnvDie6PUW5MVEMIcqfmwNkkfz25l+NABSKih4eSpI=";
  };

  cargoHash = "sha256-L927ViGgb5LchJRMd6cBks6K41xOYLNI1Q2kTKdYBgg=";

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
      otavio
      matthiasbeyer
    ];
  };
}
