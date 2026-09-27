{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
  protobufc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semcode";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "semcode";
    tag = finalAttrs.version;
    hash = "sha256-nkb4a+H11gzMGz0zBAH+G77zE+oDl9elTu+bfYmIz9k=";
  };
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  checkFlags = [
    # git test requires network connectivity
    "--skip=git"
  ];
  buildInputs = [
    openssl
    protobufc
  ];
  __structuredAttrs = true;
  cargoHash = "sha256-xOIaoOaHWYhV9z3IoIAfAaRd+AbVBuX8VKomfuFN2QM=";
  meta = {
    description = "Semantic code search tool for C/C++ codebases";
    homepage = "https://github.com/facebookexperimental/semcode";
    changelog = "https://github.com/facebookexperimental/semcode/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      razelighter777
    ];
    mainProgram = "semcode";
    platforms = lib.platforms.all;
  };
})
