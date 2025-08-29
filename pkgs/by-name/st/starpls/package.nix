{
  rustPlatform,
  lib,
  testers,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starpls";
  version = "0.1.22-unstable-2025-12-30";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    rev = "db21acd3cb24893315dd601484c7d40689589e9a";
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
      version = "v${
        lib.strings.substring 0 (builtins.stringLength finalAttrs.version - 6) finalAttrs.version
      }";
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
