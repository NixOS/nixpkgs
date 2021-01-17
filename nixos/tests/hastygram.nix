import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "hastygram";
  meta.maintainers = with lib.maintainers; [ zopieux ];

  machine =
    { ... }:
    { services.hastygram.enable = true;
      services.hastygram.extraConfig = ''
        workers = 1
        bind = "unix:/run/hastygram/hastygram.sock"
      '';

      services.nginx.enable = true;
      services.nginx.virtualHosts.localhost = {
        enableACME = false;
        forceSSL = false;
        locations."/_".proxyPass = "http://unix:/run/hastygram/hastygram.sock";
        locations."/".root = "${pkgs.python3Packages.hastygram}/frontend";
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("hastygram.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_file("/run/hastygram/hastygram.sock")

    assert "<title>hastygram" in machine.succeed("curl http://localhost/")
    assert "Server Error" in machine.succeed("curl http://localhost/_/authenticate")
    machine.succeed("curl -o /dev/null http://localhost/icon-512.png")
  '';
})
