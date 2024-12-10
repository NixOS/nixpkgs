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
  fetchpatch,
}: let
  src = fetchFromGitHub {
    owner = "bluskript";
    repo = "nix-inspect";
    rev = "c55921e1d1cf980ff6351273fde6cedd5d8fa320";
    hash = "sha256-Upz+fnWJjzt5WokjO/iaiPbqiwSrqpWjrpcFOqQ4p0E=";
  };

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    version = "0.1.2";
    postPatch = ''
      cd worker
    '';

    nativeBuildInputs = [meson ninja pkg-config];

    # TODO: Remove this patch when this pull request is merged and released: https://github.com/bluskript/nix-inspect/pull/18
    patches = [
      (fetchpatch {
        url = "https://github.com/bluskript/nix-inspect/commit/e1e05883d42ce0c7029a3d69dce14ae9d057aae6.patch";
        sha256 = "sha256-bHo+sRc9pICK0ccdiWLRNNvr8QjNCrlcwMvmUHznAtg=";
      })
    ];

    buildInputs = [
      boost
      nlohmann_json
      nixVersions.nix_2_24.dev
    ];

    mesonBuildType = "release";
  };
in
  rustPlatform.buildRustPackage {
    inherit src;
    pname = "nix-inspect";
    version = "0.1.2";

    cargoHash = "sha256-/0CrHqOL4B0Rx0ZbUpW54FiisfpW6UU4uk6wctfCX5c=";

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
