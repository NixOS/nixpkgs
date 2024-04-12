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
}: let
  src = fetchFromGitHub {
    owner = "bluskript";
    repo = "nix-inspect";
    rev = "3d0fea2bb246130825548fce331093ee9cc9c20b";
    hash = "sha256-JichXRSfTLfy+7fhbTvA89rQLkqsY2eHgEAeAHWbA9s=";
  };

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    version = "0.1.0";
    sourceRoot = "source/worker";

    nativeBuildInputs = [meson ninja pkg-config];

    buildInputs = [
      boost
      nlohmann_json
      nixVersions.nix_2_19.dev
    ];

    mesonBuildType = "release";
  };
in
  rustPlatform.buildRustPackage {
    inherit src;
    pname = "nix-inspect";
    version = "0.1.0";

    cargoHash = "sha256-FdpHdw7bg/nEG4GjYhrdIDB4MJ4n5LoWnW4mTG2Lh5I=";

    buildInputs = [workerPackage];

    postPatch = ''
      substituteInPlace src/workers.rs \
        --replace-fail 'env!("WORKER_BINARY_PATH")' '"${workerPackage}/bin/nix-inspect"'
    '';

    meta = with lib; {
      description = "A Rust package for inspecting Nix expressions";
      homepage = "https://github.com/bluskript/nix-inspect";
      license = licenses.mit;
      maintainers = with maintainers; [blusk];
      platforms = platforms.unix;
      mainProgram = "nix-inspect";
    };
  }
