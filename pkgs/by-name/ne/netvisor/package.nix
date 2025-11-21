{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,

  public_server_hostname ? "127.0.0.1",
  public_server_port ? 60072,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netvisor";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mayanayza";
    repo = "netvisor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-txP5duOx6cEFA3bGinwelxl1oJmsrMWV0XPGPjXU++A=";
  };

  sourceRoot = "${finalAttrs.src.name}/backend";

  cargoHash = "sha256-maWIZjFdVdj1VDsqkvRZArYkQAD1dDJIlgbeOvVCw/o=";

  ui = buildNpmPackage {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-ui";

    postPatch = ''
      cd ui
    '';

    npmDepsHash = "sha256-p4YHLoSwD+z3w3gPiID3Rjr9ZaaAeC+RdRzyRcBZUwk=";

    env = {
      PUBLIC_SERVER_HOSTNAME = public_server_hostname;
      PUBLIC_SERVER_PORT = toString public_server_port;
    };

    postBuild = ''
      mkdir -p $out/html
      cp -r build/* $out/html
    '';
  };

  checkFlags = [
    # Requires `/var/run/docker.sock`
    "--skip test_database_schema_backward_compatibility"
    "--skip test_host_consolidation"
    "--skip test_host_deduplication_on_create"
    "--skip test_host_upsert_merges_new_data"
    "--skip test_service_deduplication_on_create"
    "--skip test_service_deletion_cleans_up_relationships"

    # Requires internet
    "--skip test_service_definition_logo_urls_resolve"

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
