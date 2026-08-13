{
  pkgs,
  package,
  lib,
  ...
}:
let
  testPath = pkgs.hello;
in
{
  name = "vinyl";
  meta = {
    maintainers = [
      lib.maintainers.leona
      lib.maintainers.osnyx
    ];
  };

  nodes = {
    vinyl =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.nix-serve = {
          enable = true;
        };

        services.vinyl-cache = {
          inherit package;
          enable = true;
          enableFileLogging = true;
          listen = [
            {
              address = "0.0.0.0";
              port = 80;
              proto = "HTTP";
            }
            {
              name = "proxyport";
              address = "0.0.0.0";
              port = 8080;
              proto = "PROXY";
            }
            {
              address = "/var/run/vinyld/client.http.sock";
              user = "vinyl-cache";
              group = "vinyl-cache";
              mode = "660";
            }
          ]
          ++ lib.optionals (lib.versionAtLeast package.version "7.3") [
            # Support added in 7.3.0
            { address = "@asdf"; }
          ];
          config = ''
            vcl 4.1;

            backend nix-serve {
              .host = "127.0.0.1";
              .port = "${toString config.services.nix-serve.port}";
            }
          '';
        };

        networking.firewall.allowedTCPPorts = [ 80 ];
        system.extraDependencies = [ testPath ];

        assertions =
          let
            cmdline = config.systemd.services.vinyl-cache.serviceConfig.ExecStart;
          in
          map
            (pattern: {
              assertion = lib.hasInfix pattern cmdline;
              message = "Address argument `${pattern}` missing in commandline `${cmdline}`.";
            })
            (
              [
                " -a 0.0.0.0:80,HTTP "
                " -a proxyport=0.0.0.0:8080,PROXY "
                " -a /var/run/vinyld/client.http.sock,HTTP,user=vinyl-cache,group=vinyl-cache,mode=660 "
              ]
              ++ lib.optionals (lib.versionAtLeast package.version "7.3") [
                " -a @asdf,HTTP "
              ]
            );
      };

    client =
      { lib, ... }:
      {
        nix.settings = {
          require-sigs = false;
          substituters = lib.mkForce [ "http://vinyl" ];
        };
      };
  };

  testScript = ''
    from pathlib import Path
    import os

    start_all()
    vinyl.wait_for_open_port(80)
    vinyl.wait_for_unit("vinylncsa")

    client.wait_until_succeeds("curl -f http://vinyl/nix-cache-info");

    client.wait_until_succeeds("nix-store -r ${testPath}")
    client.succeed("${testPath}/bin/hello")

    output = vinyl.succeed("vinyladm status")
    print(output)
    assert "Child in state running" in output, "Unexpected vinyladm response"

    vinyl.copy_from_machine("/var/log/vinyl-cache/vinyl-cache.log")

    out_dir = os.environ.get("out", os.getcwd())
    vinyl_log = (Path(out_dir) / "vinyl-cache.log").read_text()
    assert "http://vinyl/nix-cache-info" in vinyl_log
  '';
}
