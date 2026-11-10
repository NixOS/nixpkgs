{
  lib,
  rustPlatform,
  fetchFromGitHub,
  boost,
  nlohmann_json,
  nixVersions,
  pkg-config,
  meson,
  ninja,
  stdenv,
}:
let
  nixComponents = nixVersions.nixComponents_2_35;

  # Maintained fork of the original project from bluskript/nix-inspect
  src = fetchFromGitHub {
    owner = "rszyma";
    repo = "nix-inspect";
    rev = "975d2a97ccca17f2890820d47d34b436a723233d";
    hash = "sha256-r8BqSevdYFm5RfbFAaHbXzWaj8YvoLZYmhfbhTDlCdA=";
  };

  version = "0.1.2-unstable-2026-09-12";

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    inherit version;
    postPatch = ''
      cd worker
    '';

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    buildInputs = [
      boost
      nlohmann_json
      nixComponents.nix-main
      nixComponents.nix-store
      nixComponents.nix-expr
      nixComponents.nix-cmd
      nixComponents.nix-flake
    ];

    mesonBuildType = "release";
  };
in
rustPlatform.buildRustPackage {
  inherit src;
  pname = "nix-inspect";
  inherit version;

  cargoHash = "sha256-3FTlbWSA0SKCfunQDdXu9g2aQAdAIfOTq5qJbzrRPjc=";

  buildInputs = [ workerPackage ];

  postPatch = ''
    substituteInPlace src/workers.rs \
      --replace-fail 'env!("WORKER_BINARY_PATH")' '"${workerPackage}/bin/nix-inspect-worker"'
  '';

  meta = {
    description = "Interactive TUI for inspecting nix configs and other expressions";
    homepage = "https://github.com/rszyma/nix-inspect";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blusk ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-inspect";
  };
}
