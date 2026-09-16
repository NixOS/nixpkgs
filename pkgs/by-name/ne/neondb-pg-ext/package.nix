{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  protobuf,
  llvmPackages,
  curl,
  openssl,
  postgresql_17_neon,
  postgresql_neon ? postgresql_17_neon,
}:

let
  version = "9129";
  src = fetchFromGitHub {
    owner = "neondatabase";
    repo = "neon";
    rev = "release-${version}";
    hash = "sha256-n5o4mHs6JJHTDTY0TnzRg3lKpSQKzYEe1nIXFGkRJJw=";
  };
  pgConfig = "${postgresql_neon.pg_config}/bin/pg_config";
  clangBin = lib.getExe' llvmPackages.clang "clang";
in

stdenv.mkDerivation {
  pname = "neondb-pg-ext-${lib.versions.major postgresql_neon.version}";
  inherit version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-C9EatnwZr+QjIzGa44bZPjMJptKLrpjCL2ZXJ+jpAeU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustPlatform.bindgenHook
    pkg-config
    protobuf
  ];

  buildInputs = [
    postgresql_neon
    curl
    openssl
  ];

  # Make clang available for cc-rs without overriding stdenv's CC
  postPatch = ''
    mkdir -p .bin
    ln -s ${clangBin} .bin/clang
    ln -s ${clangBin} .bin/clang++
  '';

  buildPhase = ''
    runHook preBuild
    export PATH="$PWD/.bin:$PATH"
    for ext in neon neon_rmgr neon_utils neon_test_utils neon_walredo; do
      make -C pgxn/$ext \
        PG_CONFIG=${pgConfig} \
        NEON_CARGO_ARTIFACT_TARGET_DIR=$PWD/target/release \
        CARGO_PROFILE=--release
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    export PATH="$PWD/.bin:$PATH"
    for ext in neon neon_rmgr neon_utils neon_test_utils neon_walredo; do
      make -C pgxn/$ext \
        PG_CONFIG=${pgConfig} \
        NEON_CARGO_ARTIFACT_TARGET_DIR=$PWD/target/release \
        install DESTDIR=$out
    done

    if [[ -d "$out${postgresql_neon}" ]]; then
      cp -alt "$out" "$out${postgresql_neon}"/*
      rm -r "$out${postgresql_neon}"
    fi
    if [[ -d "$out${postgresql_neon.dev}" ]]; then
      cp -alt "$out" "$out${postgresql_neon.dev}"/*
      rm -r "$out${postgresql_neon.dev}"
    fi
    if [[ -d "$out${postgresql_neon.lib}" ]]; then
      cp -alt "$out" "$out${postgresql_neon.lib}"/*
      rm -r "$out${postgresql_neon.lib}"
    fi
    if [[ -d "$out/nix/store" ]]; then
      rmdir --ignore-fail-on-non-empty "$out/nix/store" "$out/nix" || true
    fi
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    homepage = "https://neon.tech/";
    description = "PostgreSQL extensions for Neon serverless database";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
    platforms = lib.platforms.linux;
  };
}
