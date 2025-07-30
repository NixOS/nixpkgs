{
  rustPlatform,
  lib,
  testers,
  starpls,
  fetchFromGitHub,
  protobuf,
}:
let
  commit = "db21acd3cb24893315dd601484c7d40689589e9a";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starpls";
  version = "0.1.22+${lib.substring 0 5 commit}";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    rev = commit;
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
      package = starpls;
      command = "starpls version";
      version = "v0.1.22";
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
