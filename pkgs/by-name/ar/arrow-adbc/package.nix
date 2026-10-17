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

  # passthru
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arrow-adbc";
  version = "24";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-adbc";
    tag = "apache-arrow-adbc-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iwYm65b1jVZEtChwqSPNqvsGY8IlVed8ORWBfe4witk=";
  };

  vendorHash = "sha256-vVGOa2yUlKShIpW+eM2cgFktNCPZX5fbxlZ8O83aE/E=";

  # We are building the C project
  preConfigure = ''
    cd c/
  '';
  # Upstream's build invokes a custom `go build` command to build one of the
  # targets. We use buildGoModule's engineering to supply it the offline
  # `goModules` path and other GO[A-Z] environment variables. Ideally, there
  # should be setup hooks for the mechanisms of buildGoModule, that would make
  # it easier.
  modRoot = "../../go/adbc";
  inherit (finalAttrs.finalPackage.passthru.go-package) goModules;
  preBuild =
    (lib.pipe finalAttrs.finalPackage.passthru.go-package.configurePhase [
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
    finalAttrs.finalPackage.passthru.go-package.passthru.go
  ];

  cmakeFlags = map (driver: lib.cmakeBool "ADBC_DRIVER_${driver}" true) [
    "FLIGHTSQL"
    "MANAGER"
    "POSTGRESQL"
    "SQLITE"
  ];

  buildInputs = [
    fmt
    gtest
    libpq
    nanoarrow
    sqlite
  ];

  passthru = {
    go-package = buildGoModule (finalGoAttrs: {
      inherit (finalAttrs)
        pname
        version
        src
        vendorHash
        ;
      sourceRoot = "${finalAttrs.src.name}/go/adbc";
      # This derivation is not really evaluated anyway, but it is used to
      # update the vendorHash...
      dontBuild = true;
      dontInstall = true;
    });
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "apache-arrow-adbc-(.*)"
      ];
    };
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
