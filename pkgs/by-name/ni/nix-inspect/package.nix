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
    rev = "86f636b1e01579b3a63b2c778c21a818b00c3d1e";
    hash = "sha256-G5Md4ghux4LBRkPE8vzLTUWxzlQ7s1xKxZ8i3ICWZU8=";
  };

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    version = "0.1.2";
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
