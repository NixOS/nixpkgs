{
  lib,
  rustPlatform,
  fetchCrate,
  fetchFromGitHub,
  fetchurl,
  aws-lc,
  pkg-config,
  protobuf,
  zlib,
  zstd,
  libgit2,
  oniguruma,
  rust-jemalloc-sys-unprefixed,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "greptimedb";
  version = "1.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GreptimeTeam";
    repo = "greptimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cMQOqtNiCxbr44lf4zELR6qEBOPm1mCrgaQqarSCCP8=";
  };

  cargoHash = "sha256-qtvPTEWWdCn2WnDZZQQv2FMmySH0pPXWpTBjak1JPQI=";

  # packed with the gen/ files that vendoring drops; see postPatch
  substraitVersion = "0.63.0";
  substraitCrate = fetchCrate {
    pname = "substrait";
    version = finalAttrs.substraitVersion;
    hash = "sha256-PhaF+ume7uiTKxG4MOC42FUdlEgadRjByYQeq06p5VU=";
  };

  # prebuilt dashboard UI, versioned by src/servers/dashboard/VERSION
  dashboardVersion = "0.14.6";
  dashboardAssets = fetchurl {
    url = "https://github.com/GreptimeTeam/dashboard/releases/download/v${finalAttrs.dashboardVersion}/build.tar.gz";
    hash = "sha256-UGMCHRVzsL1rFfP9MOf2hRrb3W4bKimVh2z9vMoS07k=";
  };

  postPatch = ''
    # The servers build script downloads the dashboard bundle it embeds, which the
    # sandbox forbids. The release tarball unpacks to dashboard/dist/index.html,
    # which the build script then takes as already present.
    versionInSource=$(cat src/servers/dashboard/VERSION)
    if [ "$versionInSource" != "v${finalAttrs.dashboardVersion}" ]; then
      echo "dashboardAssets ${finalAttrs.dashboardVersion} does not match $versionInSource" >&2
      exit 1
    fi
    tar xzf ${finalAttrs.dashboardAssets} -C src/servers/dashboard

    # otel-arrow-rust regenerates its protos from a directory that sits outside the
    # crate, which cargo vendoring drops. Its generated sources are committed, so
    # the codegen is redundant.
    for f in "$cargoDepsCopy"/source-git-*/otel-arrow-rust-*/build.rs; do
      echo 'fn main() {}' > "$f"
    done

    # Vendoring also drops substrait's spec submodule metadata and the version
    # files build.rs generates from it. Copy them from the published crate, which
    # is packed after generation; bump substraitVersion when Cargo.lock moves.
    substraitDir=$(printf '%s\n' "$cargoDepsCopy"/source-git-*/substrait-${finalAttrs.substraitVersion}/)
    if [ ! -d "$substraitDir" ]; then
      echo "substrait-rs ${finalAttrs.substraitVersion} not found in $cargoDepsCopy" >&2
      exit 1
    fi
    mkdir -p "$substraitDir/gen"
    cp ${finalAttrs.substraitCrate}/gen/version ${finalAttrs.substraitCrate}/gen/version.in \
      "$substraitDir/gen/"

    # gRPC service futures nest deeper than the default query depth allows
    substituteInPlace src/frontend/src/lib.rs \
      --replace-fail '#![recursion_limit = "256"]' '#![recursion_limit = "512"]'
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zlib
    aws-lc
    zstd
    libgit2
    oniguruma
    rust-jemalloc-sys-unprefixed
  ];

  env = {
    # Installed binaries are stripped during fixup, so delete.
    CARGO_PROFILE_RELEASE_DEBUG = "false";

    # rust-toolchain.toml pins nightly for the crates' feature gates
    RUSTC_BOOTSTRAP = 1;
    PROTOC = lib.getExe' protobuf "protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  };

  cargoBuildFlags = [
    "--package"
    "cmd"
    # release builds serve the dashboard UI from /dashboard
    "--features"
    "servers/dashboard"
  ];

  # the suite starts a real cluster and reaches object stores over the network
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unified observability database for metrics, logs and traces";
    homepage = "https://github.com/GreptimeTeam/greptimedb";
    changelog = "https://github.com/GreptimeTeam/greptimedb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "greptime";
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})
