{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  curl,
}:
rustPlatform.buildRustPackage {
  pname = "snarkvm";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ProvableHQ";
    repo = "snarkVM";
    rev = "59b109c42d9188b8f8f361fd1eca2f134f045196";
    hash = "sha256-XpadXcWKa3Eev/BjmNCQLlQlYkniDgge5CxDUBBDSeU=";
  };

  patch = [
    ./0001-remove-update-subcommand.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-Hehi2CCRkY4qnF9EitmmY3cSbLL4MKdLWQOS4kLyRr4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
    ];

  # This test are skipped because they require a internet connection to download some files
  checkFlags = [
    "skip=package::tests::test_package_run_and_execute_match"
    "skip=file::prover::tests::test_create_and_open"
    "skip=file::verifier::tests::test_create_and_open"
    "skip=package::is_build_required::tests::test_prebuilt_package_does_not_rebuild"
    "skip=package::clean::tests::test_clean"
    "skip=package::run::tests::test_run"
    "skip=package::build::tests::test_build"
    "skip=package::deploy::tests::test_deploy"
    "skip=package::run::tests::test_run_with_nested_imports"
    "skip=package::deploy::tests::test_deploy_with_import"
    "skip=package::clean::tests::test_clean_with_import"
    "skip=package::run::tests::test_run_with_import"
    "skip=package::build::tests::test_build_with_import"
  ];

  meta = {
    description = "Zero-knowledge virtual machine";
    homepage = "https://github.com/ProvableHQ/snarkVM";
    maintainers = with lib.maintainers; [ anstylian ];
    license = [ lib.licenses.asl20 ];
    platforms = lib.platforms.unix;
  };
}
