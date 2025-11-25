{ pkgs, lib, ... }:
{
  name = "containers-reloadable";
  meta = {
    maintainers = with lib.maintainers; [ danbst ];
  };

  nodes = {
    machine =
      { lib, ... }:
      {
        containers.test1 = {
          autoStart = true;
          config.environment.etc.check.text = "client_base";
        };

        # prevent make-test-python.nix to change IP
        networking.interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [ ];

        specialisation.c1.configuration = {
          containers.test1.config = {
            environment.etc.check.text = lib.mkForce "client_c1";
            services.httpd.enable = true;
            services.httpd.adminAddr = "nixos@example.com";
          };
        };

        specialisation.c2.configuration = {
          containers.test1.config = {
            environment.etc.check.text = lib.mkForce "client_c2";
            services.nginx.enable = true;
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")

    assert "client_base" in machine.succeed("nixos-container run test1 cat /etc/check")

    with subtest("httpd is available after activating config1"):
        machine.succeed(
            "/run/booted-system/specialisation/c1/bin/switch-to-configuration test >&2",
            "[[ $(nixos-container run test1 cat /etc/check) == client_c1 ]] >&2",
            "systemctl status httpd -M test1 >&2",
        )

    with subtest("httpd is not available any longer after switching to config2"):
        machine.succeed(
            "/run/booted-system/specialisation/c2/bin/switch-to-configuration test >&2",
            "[[ $(nixos-container run test1 cat /etc/check) == client_c2 ]] >&2",
            "systemctl status nginx -M test1 >&2",
        )
        machine.fail("systemctl status httpd -M test1 >&2")
  '';

}
