import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nginx-sandbox";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ izorkin ];
  };

  # This test checks the creation and reading of a file in sandbox mode. Used simple lua script.

  nodes.machine = { pkgs, ... }: {
    nixpkgs.overlays = [
      (self: super: {
        nginx-lua = super.nginx.override {
          modules = [
            pkgs.nginxModules.lua
          ];
        };
      })
    ];
    services.nginx.enable = true;
    services.nginx.package = pkgs.nginx-lua;
    services.nginx.virtualHosts.localhost = {
      extraConfig = ''
        location /test1-write {
          content_by_lua_block {
            local create = os.execute('${pkgs.coreutils}/bin/mkdir /tmp/test1-read')
            local create = os.execute('${pkgs.coreutils}/bin/touch /tmp/test1-read/foo.txt')
            local echo = os.execute('${pkgs.coreutils}/bin/echo worked > /tmp/test1-read/foo.txt')
          }
        }
        location /test1-read {
          root /tmp;
        }
        location /test2-write {
          content_by_lua_block {
            local create = os.execute('${pkgs.coreutils}/bin/mkdir /var/web/test2-read')
            local create = os.execute('${pkgs.coreutils}/bin/touch /var/web/test2-read/bar.txt')
            local echo = os.execute('${pkgs.coreutils}/bin/echo error-worked > /var/web/test2-read/bar.txt')
          }
        }
        location /test2-read {
          root /var/web;
        }
      '';
    };
    users.users.foo.isNormalUser = true;
  };

  testScript = ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)

    # Checking write in temporary folder
    machine.succeed("$(curl -vvv http://localhost/test1-write)")
    machine.succeed('test "$(curl -fvvv http://localhost/test1-read/foo.txt)" = worked')

    # Checking write in protected folder. In sandbox mode for the nginx service, the folder /var/web is mounted
    # in read-only mode.
    machine.succeed("mkdir -p /var/web")
    machine.succeed("chown nginx:nginx /var/web")
    machine.succeed("$(curl -vvv http://localhost/test2-write)")
    assert "404 Not Found" in machine.succeed(
        "curl -vvv -s http://localhost/test2-read/bar.txt"
    )
  '';
})
