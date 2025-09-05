{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  rocksdb_9_10,
  pkg-config,
  perl,
  openssl,
  jemalloc,
  nix-update-script,
}:

let
  version = "0.30.0";
  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${version}";
    hash = "sha256-zmzo1GMy+5lUr53PhVqAdYQHMEPqBAp6M2SPocIMER0=";
  };

  frontend = buildNpmPackage {
    pname = "rauthy-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    patches = [
      # otherwise permission denied error for trying to write outside of the build directory
      ./0002-build-svelte-files-inside-the-current-directory.patch
    ];

    npmDepsHash = "sha256-Qh23e0iVZB1Iq9X9ipyrl0MTcA6yYRL6zkll8bUALqU=";
  };
in
rustPlatform.buildRustPackage {
  pname = "rauthy";
  inherit version src;

  cargoPatches = [
    # otherwise it tries to download swagger-ui at build time
    ./0001-enable-vendored-feature-for-utoipa-swagger-ui.patch
  ];

  cargoHash = "sha256-hOBmyo4Jwmnbv1Eywepn6lJbUfonUSvDzxKOGY1yTM0=";

  # TODO: remove in next version
  ROCKSDB_INCLUDE_DIR = "${rocksdb_9_10}/include";
  ROCKSDB_LIB_DIR = "${rocksdb_9_10}/lib";

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
    jemalloc
  ];

  buildInputs = [
    openssl
  ];

  preBuild = ''
    cp -r ${frontend}/lib/node_modules/frontend/dist/templates/html/ templates/html
    cp -r ${frontend}/lib/node_modules/frontend/dist/static/ static
  '';

  # tests take long, require the app and a database to be running, and some of them fail
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/sebadob/rauthy/releases/tag/v${version}";
    description = "OpenID Connect Single Sign-On Identity & Access Management";
    license = lib.licenses.asl20;
    mainProgram = "rauthy";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = with lib.platforms; linux;
  };
}
