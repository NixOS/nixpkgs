{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  rustc,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
    hash = "sha256-vaNXXXaGqYNmhonU+ANN857LAUgwv+PMcON+nBuUoeo=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  nativeBuildInputs = [
    cmake
    cargo
    rustc
  ];

  doCheck = true;

  checkPhase =
    let
      excludedTests = [
        "cbindgen_rust2cpp_build"
        "cbindgen_rust2cpp_run_cpp-exe"
        "hostbuild_build"
        "hostbuild_run_rust-host-program"
        "parse_target_triple_build"
        "rustup_proxy_build"
      ];
      excludedTestsRegex = lib.concatStringsSep "|" excludedTests;
    in
    ''
      runHook preCheck

      ctest -E "${excludedTestsRegex}"

      runHook postCheck
    '';

  meta = with lib; {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
