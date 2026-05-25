{ pkgs, package, ... }:
let
  testPath = pkgs.hello;

  # Same stateDir logic as in nixos/modules/services/web-servers/varnish/default.nix
  stateDir =
    hostName:
    if (pkgs.lib.versionOlder package.version "7") then
      "/var/run/varnish/${hostName}"
    else
      "/var/run/varnishd";
in
{
  name = "varnish";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    varnish =
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

        services.varnish = {
          inherit package;
          enable = true;
          http_address = "0.0.0.0:81";
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
              address = "${stateDir config.networking.hostName}/client.http.sock";
              user = "varnish";
              group = "varnish";
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
            cmdline = config.systemd.services.varnish.serviceConfig.ExecStart;
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
                " -a ${stateDir config.networking.hostName}/client.http.sock,HTTP,user=varnish,group=varnish,mode=660 "
                " -a 0.0.0.0:81 "
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
          substituters = lib.mkForce [ "http://varnish" ];
        };
      };
  };

  testScript = ''
    start_all()
    varnish.wait_for_open_port(80)


    client.wait_until_succeeds("curl -f http://varnish/nix-cache-info");

    client.wait_until_succeeds("nix-store -r ${testPath}")
    client.succeed("${testPath}/bin/hello")

    output = varnish.succeed("varnishadm status")
    print(output)
    assert "Child in state running" in output, "Unexpected varnishadm response"
  '';
}
