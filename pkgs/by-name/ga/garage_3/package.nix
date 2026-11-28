{
  lib,
  rustPlatform,
  fetchFromGitea,
  installShellFiles,
  libsodium,
  pkg-config,
  protobuf,
  sqlite,
  zstd,
  cacert,
  nix-update-script,
  nixosTests,
  stdenv,
  garage-webadmin,
  withWebAdmin ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "garage";
  version = "3.0.0-beta1";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JGj64EZ5554tLUQcoNffC9zY0+Oc/pCoh46quSf+Lzk=";
  };

  cargoHash = "sha256-uuhBaSRUXJ7zkSI0jZtadfXhnMV7/vBwO0se/d88VdQ=";

  nativeBuildInputs = [
    installShellFiles
    protobuf
    pkg-config
  ];

  buildInputs = [
    libsodium
    sqlite
    zstd
  ];

  checkInputs = [
    cacert
  ];

  __darwinAllowLocalNetworking = true;

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  }
  // lib.optionalAttrs withWebAdmin {
    GARAGE_WEBADMIN_DIST = garage-webadmin.override {
      npmBuildScript = "build:integrated";
    };
  };

  # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v2.4.1/nix/compile.nix#L71-L78
  # on version changes for checking if changes are required here
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "system-libs"
    "consul-discovery"
    "fjall"
    "journald"
    "k2v"
    "kubernetes-discovery"
    "lmdb"
    "metrics"
    "sqlite"
    "syslog"
    "telemetry-otlp"
  ]
  ++ lib.optional withWebAdmin "webadmin";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd garage \
      --bash <($out/bin/garage completions bash) \
      --fish <($out/bin/garage completions fish) \
      --zsh <($out/bin/garage completions zsh)
  '';

  passthru = {
    tests = nixosTests."garage_${lib.versions.major finalAttrs.version}";
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(${lib.versions.major finalAttrs.version}\\.[0-9.]+)"
      ];
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      nickcao
      _0x4A6F
      teutat3s
      herbetom
      anish
    ];
    mainProgram = "garage";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
