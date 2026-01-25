{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "martin";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DR0ZJuvMsQMx0f8vfVdsGEBlovdoBx3pgbNvlw0TImY=";
  };

  patches = [ ./dont-build-webui.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-I+sZFKbAAJ75gpXFXc3+jlsu6yWmTJC7Khi6RkYm3MQ=";

  webui = buildNpmPackage {
    pname = "martin-ui";
    inherit (finalAttrs) version;

    src = "${finalAttrs.src}/martin/martin-ui";

    postPatch = ''
      substituteInPlace src/App.tsx \
        --replace-warn "./assets" "$src/src/assets"
    '';

    npmDepsHash = "sha256-K7SngX+YpieXo9P1O+k8LblYgKCDYJDFDmGqJQqysKo=";

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

  doCheck = false;
  checkFlags = [
    "--skip function_source_schemas"
    "--skip function_source_tile"
    "--skip function_source_tilejson"
    "--skip pg_get_function_tiles"
    "--skip pg_get_function_source_ok_rewrite"
    "--skip pg_get_function_source_ok"
    "--skip pg_get_composite_source_tile_minmax_zoom_ok"
    "--skip pg_get_function_source_query_params_ok"
    "--skip pg_get_composite_source_tile_ok"
    "--skip pg_get_catalog"
    "--skip pg_get_composite_source_ok"
    "--skip pg_get_health_returns_ok"
    "--skip pg_get_table_source_ok"
    "--skip pg_get_table_source_rewrite"
    "--skip pg_null_functions"
    "--skip utils::test_utils::tests::test_bad_os_str"
    "--skip utils::test_utils::tests::test_get_env_str"
    "--skip pg_get_table_source_multiple_geom_tile_ok"
    "--skip pg_get_table_source_tile_minmax_zoom_ok"
    "--skip pg_tables_feature_id"
    "--skip pg_get_table_source_tile_ok"
    "--skip table_source_schemas"
    "--skip tables_srid_ok"
    "--skip tables_tile_ok"
    "--skip table_source"
    "--skip tables_tilejson"
    "--skip tables_multiple_geom_ok"
    "--skip pg::pool::tests::parse_version"
    "--skip pmt_get_catalog_gzip"
    "--skip pmt_get_tile_s3"
    "--skip pmt_get_tilejson"
    "--skip pmt_get_raster_gzip"
    "--skip pmt_get_tilejson_s3"
    "--skip pmt_get_raster"
    "--skip pmt_get_tilejson_gzip"
    "--skip summary::tests::summary"
  ];

  passthru.tests = {
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
