{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  libiconv,
  testers,
  nix-update-script,
  maturin,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-kFhY2ixZZrSA/YxLCQDLPjLqNWQI3zl5V1MLTPqQH60=";
  };

  cargoHash = "sha256-ik6kFS66umiHf0M1fE+6++zpZF4gJrN9LQ2l+vi9SSY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
  ];

  # Requires network access, fails in sandbox.
  doCheck = false;

  passthru = {
    tests = {
      version = testers.testVersion { package = maturin; };
      pyo3 = python3.pkgs.callPackage ./pyo3-test {
        format = "pyproject";
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
    changelog = "https://github.com/PyO3/maturin/blob/v${version}/Changelog.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "maturin";
  };
}
