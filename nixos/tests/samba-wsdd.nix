import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "samba-wsdd";
    meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

    nodes = {
      client_wsdd =
        { pkgs, ... }:
        {
          services.samba-wsdd = {
            enable = true;
            openFirewall = true;
            interface = "eth1";
            workgroup = "WORKGROUP";
            hostname = "CLIENT-WSDD";
            discovery = true;
            extraOptions = [ "--no-host" ];
          };
        };

      server_wsdd =
        { ... }:
        {
          services.samba-wsdd = {
            enable = true;
            openFirewall = true;
            interface = "eth1";
            workgroup = "WORKGROUP";
            hostname = "SERVER-WSDD";
          };
        };
    };

    testScript = ''
      client_wsdd.start()
      client_wsdd.wait_for_unit("samba-wsdd")

      server_wsdd.start()
      server_wsdd.wait_for_unit("samba-wsdd")

      client_wsdd.wait_until_succeeds(
          "echo list | ${pkgs.libressl.nc}/bin/nc -N -U /run/wsdd/wsdd.sock | grep -i SERVER-WSDD"
      )
    '';
  }
)
