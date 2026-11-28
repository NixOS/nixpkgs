{
  lib,
  aws-lc,
  buildPackages,
  cmake,
  fetchFromGitHub,
  openssl,
  pkg-config,
  protobuf,
  rust-jemalloc-sys-unprefixed,
  rustPlatform,
  sqlite,
  stdenv,
  zstd,
}:

rustPlatform.buildRustPackage (
  rec {
    pname = "fedimint";
    version = "0.13.0";

    src = fetchFromGitHub {
      owner = "fedimint";
      repo = "fedimint";
      rev = "v${version}";
      hash = "sha256-4f4ywRgU4LBh2wsxMjABV9Dr8KzcdP0np/E3T5cIK/U=";
    };

    cargoHash = "sha256-8QphXPcOT1tiAK0I/QZ3zVm+WwrwUFbNzncR3gB7Wwc=";

    nativeBuildInputs = [
      cmake
      protobuf
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      aws-lc
      openssl
    ]
    # librocksdb-sys enables unprefixed_malloc_on_supported_platforms.
    ++ lib.optional (!stdenv.hostPlatform.isMusl) rust-jemalloc-sys-unprefixed
    ++ [
      sqlite
      zstd
    ];

    outputs = [
      "out"
      "fedimintCli"
      "fedimint"
      "gateway"
      "gatewayCli"
      "devimint"
    ];

    postInstall = ''
      mkdir -p $fedimint/bin $fedimintCli/bin $gateway/bin $gatewayCli/bin $devimint/bin

      # delete fuzzing targets and other binaries no one cares about
      binsToKeep=(fedimint-cli fedimint-dbtool recoverytool fedimintd gatewayd gateway-cli devimint)
      keepPattern=$(printf "|%s" "''${binsToKeep[@]}")
      keepPattern=''${keepPattern:1}
      find "$out/bin" -maxdepth 1 -type f | grep -Ev "(''${keepPattern})" | xargs rm -f

      cp -a $releaseDir/fedimint-cli  $fedimintCli/bin/
      cp -a $releaseDir/fedimint-dbtool  $fedimintCli/bin/
      cp -a $releaseDir/fedimint-recoverytool  $fedimintCli/bin/

      cp -a $releaseDir/fedimintd  $fedimint/bin/

      cp -a $releaseDir/gateway-cli $gatewayCli/bin/

      cp -a $releaseDir/gatewayd $gateway/bin/

      cp -a $releaseDir/devimint $devimint/bin/
    '';

    env = {
      PROTOC = "${buildPackages.protobuf}/bin/protoc";
      PROTOC_INCLUDE = "${protobuf}/include";

      FEDIMINT_BUILD_FORCE_GIT_HASH = "0000000000000000000000000000000000000000";
    };

    # currently broken, will require some upstream fixes
    doCheck = false;

    meta = {
      description = "Federated E-Cash Mint";
      homepage = "https://github.com/fedimint/fedimint";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ dpc ];
      mainProgram = "fedimint-cli";
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isMusl {
    # The locked tikv-jemalloc-sys expects unprefixed symbols on musl, but the
    # system package uses a prefix there. Keep the upstream allocator build.
    preBuild = ''
      unset JEMALLOC_OVERRIDE
    '';
  }
)
