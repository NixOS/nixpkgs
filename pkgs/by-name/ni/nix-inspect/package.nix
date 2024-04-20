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
    rev = "74007c580b8282bd336130ddf354e71502b421a6";
    hash = "sha256-JichXRSfTLfy+7fhbTvA89rQLkqsY2eHgEAeAHWbA9s=";
  };

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    version = "0.1.1";
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
    version = "0.1.1";

    cargoHash = "sha256-l+R7BLgJvK9mQ89GVAdTyQX81VMoV11h5KFlMUqAH30=";

    buildInputs = [workerPackage];

    postPatch = ''
      substituteInPlace src/workers.rs \
        --replace-fail 'env!("WORKER_BINARY_PATH")' '"${workerPackage}/bin/nix-inspect"'
    '';

    meta = with lib; {
      description = "Interactive TUI for inspecting nix configs and other expressions";
      homepage = "https://github.com/bluskript/nix-inspect";
      license = licenses.mit;
      maintainers = with maintainers; [blusk];
      platforms = platforms.unix;
      mainProgram = "nix-inspect";
    };
  }
