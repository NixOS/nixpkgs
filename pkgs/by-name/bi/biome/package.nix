{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  rust-jemalloc-sys,
  zlib,
  stdenv,
  darwin,
  git,
}:
rustPlatform.buildRustPackage rec {
  pname = "biome";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "cli/v${version}";
    hash = "sha256-GZV8M/yUDMom6xvSvSfDRjcMGm+thiaTR3fggkBLmRE=";
  };

  cargoHash = "sha256-5VZGyOQAz/p4r4v8CHOTcdgolw44HtZM0NuhTw4Wx3A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      rust-jemalloc-sys
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  nativeCheckInputs = [
    git
  ];

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
