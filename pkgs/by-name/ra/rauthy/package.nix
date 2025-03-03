{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  rocksdb_8_11,
  pkg-config,
  perl,
  postgresql,
  sqlx-cli,
  openssl,
  nix-update-script,
}:

let
  version = "0.27.3";
  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${version}";
    hash = "sha256-gQ0lc86casYMftHIGHf8rEw9CI//pJHCYqb1dud46F8=";
  };

  frontend = buildNpmPackage {
    pname = "rauthy-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    patches = [
      # otherwise permission denied error for trying to write outside of the build directory
      ./0001-build-svelte-files-inside-the-current-directory.patch
    ];

    npmDepsHash = "sha256-bExsHVpLd1dKU5GJ3Kt56vTwF3tn4+2AJtETqRX3g+o=";
  };
in
rustPlatform.buildRustPackage {
  pname = "rauthy";
  inherit version src;

  cargoPatches = [
    # otherwise it tries to download swagger-ui at build time
    ./0002-enable-vendored-feature-for-utoipa-swagger-ui.patch
  ];

  cargoHash = "sha256-Zn8NvJR+ephSADBr72HGjsX84xVuIX7/yObMEYHjgJ4=";

  prePatch = ''
    cp -r ${frontend}/lib/node_modules/frontend/dist/templates/html/ templates/html
    cp -r ${frontend}/lib/node_modules/frontend/dist/static/ static
  '';

  # TODO: next version has comitted sqlx data, we can drop postgres then
  # Force sqlx to use the prepared queries
  SQLX_OFFLINE = true;
  preBuild = ''
    # start up a postgres server
    export PGDATA="$PWD/postgres-work"
    export DATABASE_URL="postgresql:///rauthy?host=$PGDATA"
    initdb -D postgres-work
    pg_ctl start -D postgres-work -o "-k $PGDATA -h \"\""
    createuser -h $PGDATA rauthy -R -S
    createdb -h $PGDATA --owner=rauthy rauthy

    # populate postgres database that will be access when building
    cargo sqlx database setup --source migrations/postgres
    cargo sqlx prepare --workspace
  '';

  ROCKSDB_INCLUDE_DIR = "${rocksdb_8_11}/include";
  ROCKSDB_LIB_DIR = "${rocksdb_8_11}/lib";

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
    postgresql
    sqlx-cli
  ];

  buildInputs = [
    openssl
  ];

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
