{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  pkg-config,

  aws-lc,
  maplibre-native,
  openssl,
  sqlite,
  zstd,

  postgresql,
  postgresqlTestHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "martin";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    tag = "martin-v${finalAttrs.version}";
    hash = "sha256-VFBdFTquqTOJQUl3m3pu5sPD8z7kvuQMclKcOhC5qGc=";
  };

  patches = [ ./dont-build-webui.patch ];

  cargoPatches = [ ./fix-build-gcc15.patch ];

  cargoHash = "sha256-yZFVK6BaaGutxDWu0WFa6HZtdoIhgSADYclz+ULAy0s=";

  webui = buildNpmPackage {
    pname = "martin-ui";
    inherit (finalAttrs) version doCheck;

    src = "${finalAttrs.src}/martin/martin-ui";

    postPatch = ''
      substituteInPlace src/App.tsx \
        --replace-warn "./assets" "$src/src/assets"
      ln -sf ${finalAttrs.src}/demo/frontend/public/favicon.ico public/_/assets/favicon.ico
    '';

    npmDepsHash = "sha256-ngYv8qtpUEiseE//tDauzvTzWJxyN2QMYvyV6ObsSvc=";

    buildPhase = ''
      runHook preBuild
      npm exec vite build
      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck
      npm run test
      runHook postCheck
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };

  # Fill in the missing implementation of the maplibre_native crate's
  # `MLN_SYSTEM` (see env below), with pkg-config. To be replaced by the
  # upstream version:
  # https://github.com/maplibre/maplibre-native-rs/pull/310
  postPatch = ''
    patch -p1 -d "$cargoDepsCopy"/source-registry-0/maplibre_native-* < ${./maplibre-native-system.patch}
  '';

  preBuild = ''
    rm -rf martin/martin-ui/dist
    cp -r ${finalAttrs.webui} martin/martin-ui/dist
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    maplibre-native
    openssl
    sqlite
    zstd
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  # Tests are time-consuming and moved to passthru.tests.withCheck.
  doCheck = false;

  checkFlags = [
    # Requires docker
    "--skip=test_nonexistent_tables_functions_generate_warning"
  ];

  passthru.tests = lib.optionalAttrs (!postgresqlTestHook.meta.broken) {
    withCheck = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
    };
  };

  env = {
    MLN_SYSTEM = 1;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=martin-v(.*)"
      "--subpackage=webui"
    ];
  };

  meta = {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
