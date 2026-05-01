{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  pkg-config,
  openssl,
  postgresql,
  postgresqlTestHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "martin";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    tag = "martin-v${finalAttrs.version}";
    hash = "sha256-wThCAR3SL454HyHAqbfGfUESPVTiOUMQDq37O/bjJbI=";
  };

  patches = [ ./dont-build-webui.patch ];

  cargoHash = "sha256-6hPZ3Db6ezPmtBT4XClERiV+MCFZgNLTnZTOeCgRln8=";

  webui = buildNpmPackage {
    pname = "martin-ui";
    inherit (finalAttrs) version doCheck;

    src = "${finalAttrs.src}/martin/martin-ui";

    postPatch = ''
      substituteInPlace src/App.tsx \
        --replace-warn "./assets" "$src/src/assets"
      ln -sf ${finalAttrs.src}/demo/frontend/public/favicon.ico public/_/assets/favicon.ico
    '';

    npmDepsHash = "sha256-ay8r+gvUVzza0GeJvrmtaEvppIc4wWjrqPGrK8oT+lA=";

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

  preBuild = ''
    rm -rf martin/martin-ui/dist
    cp -r ${finalAttrs.webui} martin/martin-ui/dist
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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

  meta = {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    teams = [ lib.teams.geospatial ];
  };
})
