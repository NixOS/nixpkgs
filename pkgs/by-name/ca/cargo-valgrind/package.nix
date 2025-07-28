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

  # Valgrind detects a memory leak in the std library of rustc 1.88 in nixos,
  # but not in the version available via rustup
  # (https://github.com/NixOS/nixpkgs/issues/428375#issuecomment-3125921626).
  # This suppresses reporting this leak.
  postPatch = ''
    cp ${./suppressions-rust-1.88} suppressions/rust-1.88
  '';

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
