{ ... }:
{
  name = "immich-vectorchord-migration";

  nodes.machine =
    { lib, pkgs, ... }:
    {
      # These tests need a little more juice
      virtualisation = {
        cores = 2;
        memorySize = 2048;
        diskSize = 4096;
      };

      environment.systemPackages = with pkgs; [ immich-cli ];

      services.immich = {
        enable = true;
        environment.IMMICH_LOG_LEVEL = "verbose";
        # Simulate an existing setup
        database.enableVectorChord = lib.mkDefault false;
        database.enableVectors = lib.mkDefault true;
      };

      # TODO: Remove when PostgreSQL 17 is supported.
      services.postgresql.package = pkgs.postgresql_16;

      specialisation."immich-vectorchord-enabled".configuration = {
        services.immich.database.enableVectorChord = true;
      };

      specialisation."immich-vectorchord-only".configuration = {
        services.immich.database = {
          enableVectorChord = true;
          enableVectors = false;
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      specBase = "${nodes.machine.system.build.toplevel}/specialisation";
      vectorchordEnabled = "${specBase}/immich-vectorchord-enabled";
      vectorchordOnly = "${specBase}/immich-vectorchord-only";
    in
    ''
      def psql(command: str):
        machine.succeed(f"sudo -u postgres psql -d ${nodes.machine.services.immich.database.name} -c '{command}'")

      def immich_works():
        machine.wait_for_unit("immich-server.service")

        machine.wait_for_open_port(2283) # Server
        machine.wait_for_open_port(3003) # Machine learning
        machine.succeed("curl --fail http://localhost:2283/")

      immich_works()

      machine.succeed("${vectorchordEnabled}/bin/switch-to-configuration test")

      immich_works()

      psql("DROP EXTENSION vectors;")
      psql("DROP SCHEMA vectors;")

      machine.succeed("${vectorchordOnly}/bin/switch-to-configuration test")

      immich_works()
    '';
}
