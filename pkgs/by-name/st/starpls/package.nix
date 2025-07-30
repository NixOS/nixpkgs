{
  rustPlatform,
  lib,
  testers,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starpls";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    # https://github.com/withered-magic/starpls/commit/96ef5d0548748745756c421960e0ebb5cfbef963
    rev = "96ef5d0548748745756c421960e0ebb5cfbef963";
    hash = "sha256-PymdSITGeSxKwcLnsJPKc73E8VDS8SSRBRRNQSKvnbU=";
  };

  cargoHash = "sha256-yovv8ox7TtSOxGW+YKYr/ED4cq7P7T7vSqoXBFhFGb4=";

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
