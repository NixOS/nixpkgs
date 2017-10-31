import ./make-test.nix ({ pkgs, ... }:

{
  name = "samba";

  meta.maintainers = [ pkgs.lib.maintainers.eelco ];

  nodes =
    { client =
        { config, pkgs, ... }:
        { fileSystems = pkgs.lib.mkVMOverride
            { "/public" = {
                fsType = "cifs";
                device = "//server/public";
                options = [ "guest" ];
              };
            };
        };

      server =
        { config, pkgs, ... }:
        { services.samba.enable = true;
          services.samba.shares.public =
            { path = "/public";
              "read only" = true;
              browseable = "yes";
              "guest ok" = "yes";
              comment = "Public samba share.";
            };
          networking.firewall.allowedTCPPorts = [ 139 445 ];
          networking.firewall.allowedUDPPorts = [ 137 138 ];
        };
    };

  # client# [    4.542997] mount[777]: sh: systemd-ask-password: command not found

  testScript =
    ''
      $server->start;
      $server->waitForUnit("samba.target");
      $server->succeed("mkdir -p /public; echo bar > /public/foo");

      $client->start;
      $client->waitForUnit("remote-fs.target");
      $client->succeed("[[ \$(cat /public/foo) = bar ]]");
    '';
})
