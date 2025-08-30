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
  fetchpatch2,
}:
let
  nixComponents = nixVersions.nixComponents_2_30;
  src = fetchFromGitHub {
    owner = "bluskript";
    repo = "nix-inspect";
    rev = "2938c8e94acca6a7f1569f478cac6ddc4877558e";
    hash = "sha256-ArwdTtlIje7yOTblkZs4aQ1+HBtEwJKkfKOiA9tY8nA=";
  };

  workerPackage = stdenv.mkDerivation {
    inherit src;

    pname = "nix-inspect-worker";
    version = "0.1.2-unstable-2025-08-14";
    postPatch = ''
      cd worker
    '';

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    patches = [
      # Upgrade to Nix 2.30 - https://github.com/bluskript/nix-inspect/pull/25
      (fetchpatch2 {
        url = "https://github.com/bluskript/nix-inspect/commit/af4dd48d69f399c7b7e3f07d5268ade606a91f22.patch";
        hash = "sha256-ipyT/zr+CEZi8EPk6Tw8V58ukUdmrtXRn+H32Y7Csuw=";
      })
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
  version = "0.1.2";

  cargoHash = "sha256-3FTlbWSA0SKCfunQDdXu9g2aQAdAIfOTq5qJbzrRPjc=";

  buildInputs = [ workerPackage ];

  postPatch = ''
    substituteInPlace src/workers.rs \
      --replace-fail 'env!("WORKER_BINARY_PATH")' '"${workerPackage}/bin/nix-inspect"'
  '';

  meta = with lib; {
    description = "Interactive TUI for inspecting nix configs and other expressions";
    homepage = "https://github.com/bluskript/nix-inspect";
    license = licenses.mit;
    maintainers = with maintainers; [ blusk ];
    platforms = platforms.unix;
    mainProgram = "nix-inspect";
  };
}
