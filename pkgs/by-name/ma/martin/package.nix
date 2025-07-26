{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "martin";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rbdHa9J2puQySBJpDKIx+3N7aolv+OIYouTCh+VkABM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e9ljRfYWx0OC9D9ziVkkwPs/oiyacZaFntmvcBFGN1U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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
  ];

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
