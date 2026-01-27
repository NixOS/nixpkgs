{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,

  public_server_protocol ? null,
  public_server_hostname ? null,
  public_server_port ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netvisor";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "mayanayza";
    repo = "netvisor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U4Iqv6HzXO417aPadMkDiO+wcdDYvL8rzIVm/axNW4o=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  cargoHash = "sha256-r21r/C5o4gDPfZaM/sa8tsixMQFoo9toVh1suWtXIJE=";

  ui = buildNpmPackage {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-ui";

    postPatch = ''
      cd ui
    '';

    npmDepsHash = "sha256-PPfLW6kYa82v+lk1BOot2LdYypsJLAXv+N6xcqarr74=";

    env =
      lib.optionalAttrs (public_server_hostname != null) {
        PUBLIC_SERVER_HOSTNAME = public_server_hostname;
      }
      // lib.optionalAttrs (public_server_protocol != null) {
        PUBLIC_SERVER_PROTOCOL = toString public_server_protocol;
      }
      // lib.optionalAttrs (public_server_port != null) {
        PUBLIC_SERVER_PORT = toString public_server_port;
      };

    postBuild = ''
      mkdir -p $out/html
      cp -r build/* $out/html
    '';
  };

  checkFlags = [
    # Requires `/var/run/docker.sock`
    "--skip test_all_tables_have_entity_mapping"
    "--skip test_database_schema_backward_compatibility"
    "--skip test_host_consolidation"
    "--skip test_host_deduplication_on_create"
    "--skip test_host_upsert_merges_new_data"
    "--skip test_service_deduplication_on_create"
    "--skip test_service_deletion_cleans_up_relationships"
    "--skip test_struct_deserialization_backward_compatibility"

    # Requires internet
    "--skip test_service_definition_logo_urls_resolve"
    "--skip test_service_patterns_are_specific_enough"

    "--skip test_full_integration"
  ];

  meta = {
    description = "Automatically discover and visually document network infrastructure";
    homepage = "https://github.com/mayanayza/netvisory";
    changelog = "https://github.com/mayanayza/netvisor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
})
