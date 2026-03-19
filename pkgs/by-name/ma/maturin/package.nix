{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  testers,
  nix-update-script,
  maturin,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "maturin";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "maturin";
    rev = "v${version}";
    hash = "sha256-OTL6Poz6FIR+zpKiaCDGsUGkm2/jMVAuOS0bV/o4F3M=";
  };

  cargoHash = "sha256-pBhKuVfq9x4kHYmE2p5ly1EXG2Sr8hHQ7pHCaERqsw0=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Requires network access, fails in sandbox.
  doCheck = false;

  passthru = {
    tests = {
      version = testers.testVersion { package = maturin; };
      pyo3 = python3.pkgs.callPackage ./pyo3-test {
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
