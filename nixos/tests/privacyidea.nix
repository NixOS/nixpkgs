# Miscellaneous small tests that don't warrant their own VM run.

import ./make-test-python.nix ({ pkgs, ...} : rec {
  name = "privacyidea";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine = { ... }: {
    virtualisation.cores = 2;

    services.privacyidea = {
      enable = true;
      secretKey = "$SECRET_KEY";
      pepper = "$PEPPER";
      adminPasswordFile = pkgs.writeText "admin-password" "testing";
      adminEmail = "root@localhost";

      # Don't try this at home!
      environmentFile = pkgs.writeText "pi-secrets.env" ''
        SECRET_KEY=testing
        PEPPER=testing
      '';
    };
    services.nginx = {
      enable = true;
      virtualHosts."_".locations."/".extraConfig = ''
        uwsgi_pass unix:/run/privacyidea/socket;
      '';
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("curl --fail http://localhost | grep privacyIDEA")
    machine.succeed("grep \"SECRET_KEY = 'testing'\" /var/lib/privacyidea/privacyidea.cfg")
    machine.succeed("grep \"PI_PEPPER = 'testing'\" /var/lib/privacyidea/privacyidea.cfg")
    machine.succeed(
        "curl --fail http://localhost/auth -F username=admin -F password=testing | grep token"
    )
  '';
})
