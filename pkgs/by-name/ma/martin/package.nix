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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    tag = "martin-v${finalAttrs.version}";
    hash = "sha256-gpNmB0MFUx8OwkCMtJ+b4wt4D+Slz4XdhJ2QyiiT2sg=";
  };

  patches = [ ./dont-build-webui.patch ];

  cargoHash = "sha256-S19UMdiMfvj85AvfMN3mLXUQKd0t314tZSqVIFns6Qk=";

  webui = buildNpmPackage {
    pname = "martin-ui";
    inherit (finalAttrs) version doCheck;

    src = "${finalAttrs.src}/martin/martin-ui";

    postPatch = ''
      substituteInPlace src/App.tsx \
        --replace-warn "./assets" "$src/src/assets"
      ln -sf ${finalAttrs.src}/demo/frontend/public/favicon.ico public/_/assets/favicon.ico
    '';

    npmDepsHash = "sha256-bObtzpBJX0a5zc3dVLPEk0pVgHRY2uKamR8YShUY9QY=";

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
