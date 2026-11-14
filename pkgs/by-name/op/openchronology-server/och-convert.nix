{
  lib,
  rustPlatform,
  cmake,
  pkg-config,
  sqlite,
  gmp,
  version,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "och-convert";
  inherit version src;

  cargoRoot = "native-store";
  buildAndTestSubdir = "native-store";
  cargoHash = "sha256-8YaQswToIfCk//u040WBkTiKMU0tX61DxZnUJUj6ahU=";
  cargoBuildFlags = [
    "--bin"
    "och-convert"
  ];

  # The crate's build script runs CMake itself, for the vendored SQLite rational extension.
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    sqlite
    gmp
  ];

  # The tests read fixtures and benchmarks that the upstream repository's CI provides.
  doCheck = false;

  meta = {
    description = "Converts OpenChronology timelines to and from .och files";
    homepage = "https://github.com/openchronology/timeline-app";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ athanclark ];
    mainProgram = "och-convert";
  };
}
