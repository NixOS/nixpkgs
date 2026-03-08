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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "influxdb3";
  version = "3.8.3";
  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "73f689bb31d5ca13c4f950fefb40d5f6e6163019";
    hash = "sha256-+eNv+/LJUBTJEL+jhkAq9sMSzFBAnuNdEaUwdWFtEMA=";
  };

  cargoHash = "sha256-gICiNHbN85gKWY635zonJg6Fed5NeqDuzdQLBGkbm6g=";

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

  env.INFLUXDB3_BUILD_VERSION = finalAttrs.version;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "aws"
    "gcp"
    "azure"
    "jemalloc_replacing_malloc"
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
})
