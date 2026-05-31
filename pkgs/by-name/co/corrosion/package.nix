{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  rustc,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corrosion";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ppuDNObfKhneD9AlnPAvyCRHKW3BidXKglD1j/LE9CM=";
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
        "cbindgen_install"
        "cbindgen_manual_build"
        "cbindgen_manual_run_cpp-exe"
        "cbindgen_rust2cpp_auto_build"
        "cbindgen_rust2cpp_auto_run_cpp-exe"
        "config_discovery_build"
        "config_discovery_run_cargo_clean"
        "config_discovery_run_config_discovery"
        "custom_target_build"
        "custom_target_run_rust-bin"
        "custom_target_run_test-exe"
        "hostbuild_build"
        "hostbuild_run_rust-host-program"
        "install_lib_build"
        "install_lib_run_main-shared"
        "install_lib_run_main-static"
      ];
      excludedTestsRegex = lib.concatStringsSep "|" excludedTests;
    in
    ''
      runHook preCheck

      ctest -E "${excludedTestsRegex}"

      runHook postCheck
    '';

  meta = {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
