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

  version ? "2.5.0",
  hash ? "sha256-5jWgH+hi0Ouqszapw00KOBHFjxlV/y4T7IB22IRaEHE=",
  cargoHash ? "sha256-xk1lMNnGp4qWK7BvgdUKIvc+cR5HDw0GFfV6q64yMso=",
  cargoPatches ? [ ],
  eol ? false,
  broken ? false,
}:
rustPlatform.buildRustPackage {
  pname = "garage";
  inherit version;

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    tag = "v${version}";
    inherit hash;
  };

  inherit cargoHash cargoPatches;

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

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
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
  ];

  postInstall =
    lib.optionalString
      ((lib.versionAtLeast version "2.3.0") && (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
      ''
        installShellCompletion --cmd garage \
          --bash <($out/bin/garage completions bash) \
          --fish <($out/bin/garage completions fish) \
          --zsh <($out/bin/garage completions zsh)
      '';

  passthru = {
    tests = lib.optionalAttrs (!eol) nixosTests."garage_${lib.versions.major version}";
  }
  // lib.optionalAttrs (!eol) {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(${lib.versions.major version}\\.[0-9.]+)"
      ];
    };
  };

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/v${version}";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      nickcao
      _0x4A6F
      teutat3s
      herbetom
      anish
    ];
    knownVulnerabilities = (lib.optional eol "Garage version ${version} is EOL");
    inherit broken;
    mainProgram = "garage";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
