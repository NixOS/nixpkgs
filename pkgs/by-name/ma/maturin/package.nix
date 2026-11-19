{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  testers,
  nix-update-script,
  python3Packages,
  pkg-config,
  zstd,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "maturin";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-elK82eg/m33GYNWeZUSfKxFVJS6fMRatHl66NgvxcxE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WRVXmhwhbOf2Isjvyqw3d4scA5Vs8Vkyy1m7WC3xb0s=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-rust
  ];

  env = {
    MATURIN_NO_INSTALL_RUST = "1";
    # setup.py otherwise disables all default features
    MATURIN_SETUP_ARGS = "--features default";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    pkg-config
  ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  optional-dependencies = {
    patchelf = [ python3Packages.patchelf ];
    zig = [ python3Packages.ziglang ];
  };

  # Requires network access, fails in sandbox.
  doCheck = false;

  passthru = {
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      pyo3 = python3Packages.callPackage ./pyo3-test {
        pyproject = true;
        buildAndTestSubdir = "examples/word-count";
        preConfigure = "";

        nativeBuildInputs = with rustPlatform; [
          cargoSetupHook
          maturinBuildHook
        ];
      };
    };

    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  pythonImportsCheck = [ "maturin" ];

  meta = {
    description = "Build and publish Rust crates Python packages";
    longDescription = ''
      Build and publish Rust crates with PyO3, rust-cpython, and
      cffi bindings as well as Rust binaries as Python packages.

      This project is meant as a zero-configuration replacement for
      setuptools-rust and Milksnake. It supports building wheels for
      Python and can upload them to PyPI.
    '';
    homepage = "https://github.com/PyO3/maturin";
    changelog = "https://github.com/PyO3/maturin/blob/v${finalAttrs.version}/Changelog.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      getchoo
      miniharinn
    ];
    mainProgram = "maturin";
  };
})
