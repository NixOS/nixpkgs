# Miscellaneous small tests that don't warrant their own VM run.

import ./make-test-python.nix ({ pkgs, ...} : rec {
  name = "privacyidea";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ fpletz ];
  };

  machine = { ... }: {
    virtualisation.cores = 2;
    virtualisation.memorySize = 512;

    services.privacyidea = {
      enable = true;
      secretKey = "testing";
      pepper = "testing";
      adminPasswordFile = pkgs.writeText "admin-password" "testing";
      adminEmail = "root@localhost";
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
    machine.succeed(
        "curl --fail http://localhost/auth -F username=admin -F password=testing | grep token"
    )
  '';
})
