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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    tag = version;
    sha256 = "sha256-sVW3zNe0a9iQQ0vRWJofqG4gwUJ/w0U4ugVyMNtWX98=";
  };

  cargoHash = "sha256-sRJGnbQFCk+SJtG/hnde+8ggZuutrdk0279ziickmnA=";

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

  # Valgrind detects a memory leak in the std library of rustc 1.88 in nixos,
  # but not in the version available via rustup
  # (https://github.com/NixOS/nixpkgs/issues/428375#issuecomment-3125921626).
  # This suppresses reporting this leak.
  postPatch = ''
    cp ${./suppressions-rust-1.88} suppressions/rust-1.88
  '';

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
}
