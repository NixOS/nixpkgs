{
  stdenv,
  lib,
  fetchFromGitHub,

  # rust
  rustPlatform,
  protobuf,
  rust-jemalloc-sys,

  # nodejs
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  patchelf,
  nodejs,

  # meta
  nix-update-script,
  nixosTests,
}:

let
  pname = "quickwit";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = "quickwit";
    tag = "v${version}";
    hash = "sha256-6PpnpacZjycTlbwgTtyHmY7PRFzPHq6yxYQnLZRAO6o=";
  };

  quickwit-ui = stdenv.mkDerivation (finalAttrs: {
    pname = "quickwit-ui";
    inherit version;
    src = "${src}/quickwit/quickwit-ui";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/quickwit/quickwit-ui/yarn.lock";
      hash = "sha256-PDADzz4WX0R1McPQYu6BhRnciDjtzgO+fYYmFpq24/g=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      yarnInstallHook
      nodejs
    ];

    dontStrip = true;
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;

  buildInputs = [ rust-jemalloc-sys ];

  postPatch = ''
    substituteInPlace ./quickwit-ingest/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-codegen/example/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-proto/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
  '';

  sourceRoot = "${src.name}/quickwit";
  cargoHash = "sha256-bjDoBdpJg4o7djFoy7YOK7BCdLioL6MHDWFgtczf1sw=";

  # matches workflow for building docker images closest
  cargoBuildFlags = [
    "--package=quickwit-cli"
    "--bin=quickwit"
  ];

  preBuild = ''
    mkdir -p quickwit-ui/build
    cp -r ${quickwit-ui}/* quickwit-ui/build
  '';

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";

    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

    # needed for internal protobuf c wrapper library
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  };

  passthru = {
    tests = {
      inherit (nixosTests) quickwit;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Sub-second search & analytics engine on cloud storage";
    homepage = "https://quickwit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
    mainProgram = "quickwit";
  };
})
