{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  python3,
  rust-jemalloc-sys-unprefixed,
  rustc,
  makeWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "influxdb3";
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "8daccb7ee8f82ffae99b25236af9645fd60e448b";
    hash = "sha256-tHnLD5W3KQ1cILRHNmXAi4lvQQSBVUPxYCXmXLMLwIs=";
  };

  cargoHash = "sha256-KnmaIbK/2tRXjCpOLHcadIX8Od7lVDOwZ+FgE+yFE+Q=";

  nativeBuildInputs = [
    makeWrapper
    protobuf
    rustc.llvmPackages.lld
  ];

  buildInputs = [
    rust-jemalloc-sys-unprefixed
    python3
  ];

  env = {
    GIT_HASH = "000000000000000000000000000000000000000000000000000";
    GIT_HASH_SHORT = "0000000";
    PYO3_PYTHON = lib.getExe python3;
  };

  postPatch = ''
    # We provide GIT_HASH and GIT_HASH_SHORT ourselves
    rm influxdb3_process/build.rs
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "aws"
    "gcp"
    "azure"
    "jemalloc_replacing_malloc"
    "system-py"
  ];

  postInstall = ''
    wrapProgram $out/bin/influxdb3 \
      --set PYTHONHOME ${python3} \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          rust-jemalloc-sys-unprefixed
          python3
        ]
      }
  '';

  # Tests require running instance
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(3.*)"
    ];
  };

  meta = {
    description = "Scalable datastore for metrics, events, and real-time analytics";
    homepage = "https://github.com/influxdata/influxdb";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oddlama ];
    mainProgram = "influxdb3";
  };
}
