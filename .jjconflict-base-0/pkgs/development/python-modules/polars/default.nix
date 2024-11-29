{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  cmake,
  darwin,
  fetchFromGitHub,
  pkg-config,
  pkgs, # zstd hidden by python3Packages.zstd
  pytestCheckHook,
  pytest-codspeed ? null, # Not in Nixpkgs
  pytest-cov,
  pytest-xdist,
  pytest-benchmark,
  rustc,
  rustPlatform,
  runCommand,

  mimalloc,
  jemalloc,
  rust-jemalloc-sys,
  # Another alternative is to try `mimalloc`
  polarsMemoryAllocator ? mimalloc, # polarsJemalloc,
  polarsJemalloc ?
    let
      jemalloc' = rust-jemalloc-sys.override {
        jemalloc = jemalloc.override {
          # "libjemalloc.so.2: cannot allocate memory in static TLS block"

          # https://github.com/pola-rs/polars/issues/5401#issuecomment-1300998316
          disableInitExecTls = true;
        };
      };
    in
    assert builtins.elem "--disable-initial-exec-tls" jemalloc'.configureFlags;
    jemalloc',

  polars,
  python,
}:

let
  version = "1.12.0";

  # Hide symbols to prevent accidental use
  rust-jemalloc-sys = throw "polars: use polarsMemoryAllocator over rust-jemalloc-sys";
  jemalloc = throw "polars: use polarsMemoryAllocator over jemalloc";
in

buildPythonPackage {
  pname = "polars";
  inherit version;

  src = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    rev = "py-${version}";
    hash = "sha256-q//vt8FvVKY9N/BOIoOwxaSB/F/tNX1Zl/9jd0AzSH4=";
  };

  # Do not type-check assertions because some of them use unstable features (`is_none_or`)
  postPatch = ''
    while IFS= read -r -d "" path ; do
      sed -i 's \(\s*\)debug_assert! \1#[cfg(debug_assertions)]\n\1debug_assert! ' "$path"
    done < <( find -iname '*.rs' -print0 )
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "numpy-0.21.0" = "sha256-u0Z+6L8pXSPaA3cE1sUpY6sCoaU1clXUcj/avnNzmsw=";
      "polars-parquet-format-2.10.0" = "sha256-iB3KZ72JSp7tJCLn9moukpDEGf9MUos04rIQ9rDGWfI=";
    };
  };

  requiredSystemFeatures = [ "big-parallel" ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    cargo
    pkg-config
    cmake # libz-ng-sys
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
    rustc
  ];

  buildInputs =
    [
      polarsMemoryAllocator
      (pkgs.__splicedPackages.zstd or pkgs.zstd)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;

    # https://github.com/NixOS/nixpkgs/blob/5c38beb516f8da3a823d94b746dd3bf3c6b9bbd7/doc/languages-frameworks/rust.section.md#using-community-maintained-rust-toolchains-using-community-maintained-rust-toolchains
    # https://discourse.nixos.org/t/nixpkgs-rustplatform-and-nightly/22870
    RUSTC_BOOTSTRAP = true;

    # Several `debug_assert!` statements use the unstable `Option::is_none_or` method
    RUSTFLAGS = lib.concatStringsSep " " (
      [
        "-Cdebug_assertions=n"
      ]
      ++ lib.optionals (polarsMemoryAllocator.pname == "mimalloc") [
        "--cfg use_mimalloc"
      ]
    );
    RUST_BACKTRACE = true;
  };

  dontUseCmakeConfigure = true;

  maturinBuildFlags = [
    "-m"
    "py-polars/Cargo.toml"
  ];

  postInstall = ''
    # Move polars.abi3.so -> polars.so
    local polarsSo=""
    local soName=""
    while IFS= read -r -d "" p ; do
      polarsSo=$p
      soName="$(basename "$polarsSo")"
      [[ "$soName" == polars.so ]] && break
    done < <( find "$out" -iname "polars*.so" -print0 )
    [[ -z "''${polarsSo:-}" ]] && echo "polars.so not found" >&2 && exit 1
    if [[ "$soName" != polars.so ]] ; then
      mv "$polarsSo" "$(dirname "$polarsSo")/polars.so"
    fi
  '';

  pythonImportsCheck = [
    "polars"
  ];

  passthru.tests.dynloading-1 =
    runCommand "polars-dynloading-1"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            ps.pyarrow
            polars
          ]))
        ];
      }
      ''
        ((LD_DEBUG=libs python) |& tee $out | tail) << \EOF
        import pyarrow
        import polars
        EOF
        touch $out
      '';
  passthru.tests.dynloading-2 =
    runCommand "polars-dynloading-2"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            ps.pyarrow
            polars
          ]))
        ];
        failureHook = ''
          sed "s/^/    /" $out >&2
        '';
      }
      ''
        ((LD_DEBUG=libs python) |& tee $out | tail) << \EOF
        import polars
        import pyarrow
        EOF
      '';
  passthru.tests.pytest = stdenv.mkDerivation {
    pname = "${polars.pname}-pytest";

    inherit (polars) version src;

    requiredSystemFeatures = [ "big-parallel" ];

    sourceRoot = "source/py-polars";
    postPatch = ''
      for f in * ; do
        [[ "$f" == "tests" ]] || \
        [[ "$f" == "pyproject.toml" ]] || \
        rm -rf "$f"
      done
      for pat in "__pycache__" "*.pyc" ; do
        find -iname "$pat" -exec rm "{}" ";"
      done
    '';
    dontConfigure = true;
    dontBuild = true;

    doCheck = true;
    checkPhase = "pytestCheckPhase";
    nativeBuildInputs = [
      (python.withPackages (ps: [
        polars
        ps.aiosqlite
        ps.altair
        ps.boto3
        ps.deltalake
        ps.flask
        ps.flask-cors
        ps.fsspec
        ps.gevent
        ps.hypothesis
        ps.jax
        ps.jaxlib
        (ps.kuzu or null)
        ps.moto
        ps.nest-asyncio
        ps.numpy
        ps.openpyxl
        ps.pandas
        ps.pyarrow
        ps.pydantic
        (ps.pyiceberg or null)
        ps.sqlalchemy
        ps.torch
        ps.xlsx2csv
        ps.xlsxwriter
        ps.zstandard
        ps.cloudpickle
      ]))
    ];
    nativeCheckInputs = [
      pytestCheckHook
      pytest-codspeed
      pytest-cov
      pytest-xdist
      pytest-benchmark
    ];

    pytestFlagsArray = [
      "-n auto"
      "--dist loadgroup"
      ''-m "slow or not slow"''
    ];
    disabledTests = [
      "test_read_kuzu_graph_database" # kuzu
      "test_read_database_cx_credentials" # connectorx

      # adbc_driver_.*
      "test_write_database_append_replace"
      "test_write_database_create"
      "test_write_database_create_quoted_tablename"
      "test_write_database_adbc_temporary_table"
      "test_write_database_create"
      "test_write_database_append_replace"
      "test_write_database_errors"
      "test_write_database_errors"
      "test_write_database_create_quoted_tablename"

      # Internet access:
      "test_read_web_file"

      # Untriaged
      "test_pickle_lazyframe_nested_function_udf"
      "test_serde_udf"
      "test_hash_struct"
    ];
    disabledTestPaths = [
      "tests/benchmark"
      "tests/docs"

      "tests/unit/io/test_iceberg.py" # Package pyiceberg
      "tests/unit/io/test_spreadsheet.py" # Package fastexcel

      # Wrong altair version
      "tests/unit/operations/namespaces/test_plot.py"

      # adbc
      "tests/unit/io/database/test_read.py"

      # Untriaged
      "tests/unit/cloud/test_prepare_cloud_plan.py"
      "tests/unit/io/cloud/test_cloud.py"
    ];

    installPhase = "touch $out";
  };

  meta = {
    description = "Dataframes powered by a multithreaded, vectorized query engine, written in Rust";
    homepage = "https://github.com/pola-rs/polars";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      SomeoneSerge
    ];
    mainProgram = "polars";
    platforms = lib.platforms.all;
  };
}
