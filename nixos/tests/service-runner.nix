import ./make-test-python.nix ({ pkgs, ... }: {
  name = "service-runner";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ roberth ];
  };

  nodes = {
    machine = { pkgs, lib, ... }: {
      services.nginx.enable = true;
      services.nginx.virtualHosts.machine.root = pkgs.runCommand "webroot" {} ''
        mkdir $out
        echo 'yay' >$out/index.html
      '';
      systemd.services.nginx.enable = false;
    };

  };

  testScript = { nodes, ... }: ''
    url = "http://localhost/index.html"

    with subtest("check systemd.services.nginx.runner"):
        machine.fail(f"curl {url}")
        machine.succeed(
            """
            mkdir -p /run/nginx /var/log/nginx /var/cache/nginx
            ${nodes.machine.config.systemd.services.nginx.runner} >&2 &
            echo $!>my-nginx.pid
            """
        )
        machine.wait_for_open_port(80)
        machine.succeed(f"curl -f {url}")
        machine.succeed("kill -INT $(cat my-nginx.pid)")
        machine.wait_for_closed_port(80)
  '';
})
