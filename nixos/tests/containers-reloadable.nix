import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  client_base = {
    containers.test1 = {
      autoStart = true;
      config = {
        environment.etc.check.text = "client_base";
      };
    };

    # prevent make-test-python.nix to change IP
    networking.interfaces = {
      eth1.ipv4.addresses = lib.mkOverride 0 [ ];
    };
  };
in {
  name = "containers-reloadable";
  meta = {
    maintainers = with lib.maintainers; [ danbst ];
  };

  nodes = {
    client = { ... }: {
      imports = [ client_base ];
    };

    client_c1 = { lib, ... }: {
      imports = [ client_base ];

      containers.test1.config = {
        environment.etc.check.text = lib.mkForce "client_c1";
        services.httpd.enable = true;
        services.httpd.adminAddr = "nixos@example.com";
      };
    };
    client_c2 = { lib, ... }: {
      imports = [ client_base ];

      containers.test1.config = {
        environment.etc.check.text = lib.mkForce "client_c2";
        services.nginx.enable = true;
      };
    };
  };

  testScript = {nodes, ...}: let
    c1System = nodes.client_c1.config.system.build.toplevel;
    c2System = nodes.client_c2.config.system.build.toplevel;
  in ''
    client.start()
    client.wait_for_unit("default.target")

    assert "client_base" in client.succeed("nixos-container run test1 cat /etc/check")

    with subtest("httpd is available after activating config1"):
        client.succeed(
            "${c1System}/bin/switch-to-configuration test >&2",
            "[[ $(nixos-container run test1 cat /etc/check) == client_c1 ]] >&2",
            "systemctl status httpd -M test1 >&2",
        )

    with subtest("httpd is not available any longer after switching to config2"):
        client.succeed(
            "${c2System}/bin/switch-to-configuration test >&2",
            "[[ $(nixos-container run test1 cat /etc/check) == client_c2 ]] >&2",
            "systemctl status nginx -M test1 >&2",
        )
        client.fail("systemctl status httpd -M test1 >&2")
  '';

})
