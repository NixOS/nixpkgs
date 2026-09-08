{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kache";
  version = "0.20.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cYiLaLCP7EtMH0VeI+Pxlt7nY1RSXG5j9tGtmia3Elk=";
  };

  cargoHash = "sha256-tPkrz+5soOmMSRjwM7GUFgVKK9fmzryKCZk2U+ui5jk=";

  cargoBuildFlags = [
    "-p"
    "kache"
  ];
  cargoTestFlags = [
    "-p"
    "kache"
    "--bins" # exclude integration tests
  ];

  # The tmutil xattr test shells out to /usr/bin/tmutil which isn't in the sandbox.
  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "--skip=store::tests::test_exclude_from_indexing_sets_tmutil_xattr";

  # planner_client / remote_backend tests bind 127.0.0.1
  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ cacert ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more";
    homepage = "https://github.com/kunobi-ninja/kache";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
