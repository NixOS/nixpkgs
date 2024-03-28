import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "ocis";

    meta.maintainers = with lib.maintainers; [ payas ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;

        environment.etc = {
          "ocis/ocis.env".text = ''
            OCIS_JWT_SECRET=foobar
          '';
        };

        services.ocis = {
          enable = true;
          environmentFile = "/etc/ocis/ocis.env";
          settings = {
            CS3_ALLOW_INSECURE = "true";
            OCIS_INSECURE_BACKENDS = "true";
            TLS_INSECURE = "true";
            TLS_SKIP_VERIFY_CLIENT_CERT = "true";
            WEBDAV_ALLOW_INSECURE = "true";
            OCIS_INSECURE = "true";
            IDP_TLS = "false";

            GATEWAY_STORAGE_USERS_MOUNT_ID = "123";
            GRAPH_APPLICATION_ID = "1234";
            IDM_IDPSVC_PASSWORD = "password";
            IDM_REVASVC_PASSWORD = "password";
            IDM_SVC_PASSWORD = "password";
            IDP_ISS = "https://localhost:9200";
            OCIS_JWT_SECRET = "foo";
            OCIS_LDAP_BIND_PASSWORD = "password";
            OCIS_MACHINE_AUTH_API_KEY = "foo";
            OCIS_MOUNT_ID = "123";
            OCIS_SERVICE_ACCOUNT_ID = "foo";
            OCIS_SERVICE_ACCOUNT_SECRET = "foo";
            OCIS_SYSTEM_USER_API_KEY = "foo";
            OCIS_SYSTEM_USER_ID = "123";
            OCIS_TRANSFER_SECRET = "foo";
            STORAGE_USERS_MOUNT_ID = "123";
          };
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("ocis.service")
      # wait for ocis to fully come up
      machine.sleep(30)

      with subtest("ocis service starts"):
          machine.succeed("${lib.getExe pkgs.ocis-bin} version")
    '';
  }
)
