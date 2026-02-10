{
  rustPlatform,
  lib,
  testers,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starpls";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t9kdpBKyGM61CKhtfO5urVVzyKpL0bX0pZuf0djDdCw=";
  };

  cargoHash = "sha256-5xYfQRm7U7sEQiJEfjaLznoXUxHsxnLmIEA/OxTkjFg=";

  nativeBuildInputs = [
    protobuf
  ];

  # The tests assume Bazel build and environment variables set like
  # RUNFILES_DIR which don't have an equivalent in Cargo.
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "starpls version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Language server for Starlark";
    homepage = "https://github.com/withered-magic/starpls";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "starpls";
  };
})
