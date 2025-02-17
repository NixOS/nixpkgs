{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  rust-jemalloc-sys,
  zlib,
  gitMinimal,
}:
rustPlatform.buildRustPackage rec {
  pname = "biome";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "cli/v${version}";
    hash = "sha256-oK1tCPoTeUHvVdi+ym4J5xEj2NIi2zHQpNU1KUchQfY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lo4IAStdv1CW/cQYzRDLzDwsDqCwoo5xKen2Rti9kPU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    rust-jemalloc-sys
    zlib
  ];

  nativeCheckInputs = [ gitMinimal ];

  cargoBuildFlags = [ "-p=biome_cli" ];
  cargoTestFlags =
    cargoBuildFlags
    ++
    # skip a broken test from v1.7.3 release
    # this will be removed on the next version
    [ "-- --skip=diagnostics::test::termination_diagnostic_size" ];

  env = {
    BIOME_VERSION = version;
    LIBGIT2_NO_VENDOR = 1;
  };

  preCheck = ''
    # tests assume git repository
    git init

    # tests assume $BIOME_VERSION is unset
    unset BIOME_VERSION
  '';

  meta = {
    description = "Toolchain of the web";
    homepage = "https://biomejs.dev/";
    changelog = "https://github.com/biomejs/biome/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      isabelroses
    ];
    mainProgram = "biome";
  };
}
