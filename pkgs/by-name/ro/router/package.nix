{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  protobuf,
  elfutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "router";
  version = "1.60.1";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = "router";
    tag = "v${version}";
    hash = "sha256-r4t7tyB1FjQ6aVL/ympaeqT6rn+dhppXYAiSHJ+jq3s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ETd/U5lovU9ZY+uq8pJmbZEHWmemrG8y79KqV84bbUA=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs = [
    elfutils
  ];

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix { };

  checkFlags = [
    "--skip=query_planner::tests::missing_typename_and_fragments_in_requires"
    "--skip=router::event::schema::tests::schema_by_url"
    "--skip=router::event::schema::tests::schema_no_watch"
    "--skip=router::event::schema::tests::schema_success_fail_success"
    "--skip=services::layers::persisted_queries::tests::pq_layer_freeform_graphql_with_safelist_log_unknown_true"
  ];

  meta = with lib; {
    description = "Configurable, high-performance routing runtime for Apollo Federation";
    homepage = "https://www.apollographql.com/docs/router/";
    license = licenses.elastic20;
    maintainers = [ maintainers.bbigras ];
  };
}
