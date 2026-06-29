{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  nanoarrow,
  fmt,
  gtest,
  libpq,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arrow-adbc";
  version = "23";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-adbc";
    tag = "apache-arrow-adbc-${finalAttrs.version}";
    hash = "sha256-33JUx4ZI+BHIZMvlCO43mjU34zShJZGQpAkqRrvgl2w=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-uGxCTllRNtXkrl31d88TOK36X09ylo++gtorx0uFR8A=";

  # We are building the C project
  preConfigure = ''
    cd c/
  '';
  # Upstream's build invoces a custom `go build` command to build one of the
  # targets. We use buildGoModule's engineering to supply it the offline
  # `goModules` path and other GO[A-Z] environment variables. Ideally, there
  # should be setup hooks for the mechanisms of buildGoModule, that would make
  # it easier.
  modRoot = "../../go/adbc";
  inherit (finalAttrs.finalPackage.passthru.bigquery-go-package) goModules;
  preBuild =
    (lib.pipe finalAttrs.finalPackage.passthru.bigquery-go-package.configurePhase [
      # Make that this configure phase doesn't run our configure hooks.
      (lib.replaceString "runHook preConfigure" "")
      (lib.replaceString "runHook postConfigure" "")
    ])
    # Return to original meson build directory.
    + ''
      cd ../../c/build
    '';

  nativeBuildInputs = [
    # NOTE that the meson build system has a bug that it puts a few shared
    # objects in $out and not in $out/lib.
    cmake
    pkg-config
    finalAttrs.finalPackage.passthru.bigquery-go-package.passthru.go
  ];

  cmakeFlags = map (driver: lib.cmakeBool driver true) [
    "ADBC_DRIVER_FLIGHTSQL"
    "ADBC_DRIVER_MANAGER"
    "ADBC_DRIVER_POSTGRESQL"
    "ADBC_DRIVER_SQLITE"
    "ADBC_DRIVER_SNOWFLAKE"
    "ADBC_DRIVER_BIGQUERY"
  ];

  buildInputs = [
    nanoarrow
    fmt
    gtest
    libpq
    sqlite
  ];

  passthru = {
    bigquery-go-package = buildGoModule (finalGoAttrs: {
      inherit (finalAttrs)
        pname
        version
        src
        vendorHash
        ;
      sourceRoot = "source/go/adbc";
      # This derivation is not really evaluated anyway, but it is used to
      # update the vendorHash... TODO: Check that nix-update is capable of
      # updating vendorHash automatically.
      dontBuild = true;
      dontInstall = true;
    });
  };

  meta = {
    description = "Database connectivity API standard and libraries for Apache Arrow";
    homepage = "https://arrow.apache.org/adbc/";
    changelog = "https://github.com/apache/arrow-adbc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.afl20;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
