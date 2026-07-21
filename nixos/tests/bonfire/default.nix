{
  name = "Bonfire";

  nodes = {
    machine =
      { pkgs, lib, ... }:
      {
        # Explanation: increased to avoid:
        # Kernel panic - not syncing: Out of memory
        # as soon as running the initial migration of the PostgreSQL schema.
        virtualisation.memorySize = 4096;

        environment.systemPackages = [
          pkgs.firefox-unwrapped
          (pkgs.callPackage ./selenium.nix { })
        ];

        networking.domain = "localdomain";

        services.bonfire = {
          enable = true;

          settings = {
            HOSTNAME = "localhost";
            PUBLIC_PORT = 80;
          };
          postgresql.enable = true;
          meilisearch.enable = true;
          nginx = {
            enable = true;
            virtualHost = {
              serverAliases = [
                "localhost"
                "localhost.localdomain"
              ];
              forceSSL = false;
              enableACME = false;
            };
          };
        };

        # Remark(security): those credentials are used in integration tests,
        # this is NOT a security issue.
        environment.etc = {
          # openssl rand -hex 128
          "credstore/bonfire.ENCRYPTION_SALT".text =
            "fde9939363a25b2696a7cfd738afcb19f82e2212bca4124d2c70102f3809974c618aeaa279e4daa062b53e07e7d14b4297409a582389a94bac247de13da116d76d6644174d21ad3814ddd7269696997447b8c8fb5f75aa757a8f32148708bb38bf0d66f1dd4a206e9ab3b3818f79dc48303c9375fa68210dbd8567f3a5bcf4f2";
          # openssl rand -hex 25
          "credstore/bonfire.POSTGRES_PASSWORD".text = "ced4a928ed2305630f7865a160b26bc6ab690c445529340fcf";
          # openssl rand -hex 40
          "credstore/bonfire.RELEASE_COOKIE".text =
            "1255749c5082f5c64d6984231a02095f6273875363008a0a6ed2c413bbd7ed66249eeebf8abbae3d";
          # openssl rand -hex 128
          "credstore/bonfire.SECRET_KEY_BASE".text =
            "0da76ae83b6e2170d3d501ac000dfe96adc820d16cbf54567188f206c9322dcfaf5fac1c5fc6ab742249ff28b69e7b06addc69e02e49290319bb3cc8df0aff920e1f812cf6906ac4711425a7bb7af2f5cf78e03039c8812f04eb2f1ce1ef31a1ff81bc6d4de06ec524171310f6c7fb2ac832f387725842667870081311386b82";
          # openssl rand -hex 128
          "credstore/bonfire.SIGNING_SALT".text =
            "3278f788f120031c3d2b8dc480fce1dba38b6ce3f16de17df443e24c66a689d75e52516beec260a3f3bf53e8637c7e66591126e25a526dd25e3e26383124656eb9ad94441c31f278852a55cfe8083e8a0fef6b061fa8c34cbe26169a3dd43854c719c2ad269449fe9172193b031b5f76c16813fb7ec0a195289b6eb5ccfaa1ca";
        };

        services.meilisearch.masterKeyFile = pkgs.writeText "meilisearch.masterKeyFile" "675b2c63f569d0bb3f872517b903fa9ea3ddce19d5766c80a8";
      };
  };

  interactive = {
    # HowTo(debug):
    # nix -L run -f. nixosTests.bonfire.driverInteractive
    # python> start_all()
    # Then run the printed ssh command.
    sshBackdoor.enable = true;

    nodes.machine =
      { pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 80 ];
        virtualisation.forwardPorts = [
          # HowTo(debug):
          # nix -L run -f. nixosTests.bonfire.driverInteractive
          # python> start_all()
          # firefox http://localhost:4000
          {
            from = "host";
            host.port = 4000;
            guest.port = 80;
          }
        ];

      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.wait_for_unit("postgresql.target")
      machine.wait_for_unit("nginx.service")

      with subtest("start bonfire"):
        machine.wait_for_unit("bonfire.service")
        machine.wait_for_open_port(${toString nodes.machine.services.bonfire.settings.PUBLIC_PORT})
        machine.wait_for_open_port(${toString nodes.machine.services.bonfire.settings.SERVER_PORT})

      # ToDo(security): whenever bonfire supports Unix socket
      # with subtest("check bonfire socket"):
      #   socket="/run/bonfire/socket"
      #   machine.wait_for_file(socket)
      #   machine.succeed(
      #     f'[[ "$(stat -c %U {socket})" == "bonfire" ]]',
      #     f'[[ "$(stat -c %G {socket})" == "bonfire" ]]',
      #     f'[[ "$(stat -c %a {socket})" == "660" ]]',
      #   )

      with subtest("Web interface"):
        machine.succeed("PYTHONUNBUFFERED=1 selenium-test")
    '';
}
