import ./make-test-python.nix ({ pkgs, ... }:

  {
    name = "samba-wsdd2";
    meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

    nodes = {
      server_wsdd2 = { ... }: {
        services.samba-wsdd2 = {
          enable = true;
          openFirewall = true;
          interface = "eth1";
          workgroup = "WORKGROUP";
          hostname = "SERVER-WSDD";
        };
      };
    };

    testScript = ''
      server_wsdd2.start()
      server_wsdd2.wait_for_unit("samba-wsdd2")
    '';
  })
