import ./make-test.nix ({ pkgs, lib, ... }:

let
  helloScript = pkgs.writeShellScriptBin "hello" ''
    echo "Status: 200 OK"
    echo
    echo "$out says: Hello World!"
  '';

  mkServer = extraConfig: { ... }:
    lib.mkMerge [
      { services.fcgiwrap.enable = true;
        services.nginx.enable = true;
        services.nginx.commonHttpConfig = ''
          error_log syslog:server=unix:/dev/log;
          access_log syslog:server=unix:/dev/log;
        '';
        services.nginx.virtualHosts."_".locations."/".extraConfig = ''
          fastcgi_param SCRIPT_FILENAME ${helloScript}/bin/hello;
          fastcgi_pass  unix:/run/fcgiwrap.sock;
        '';
      }
      extraConfig
    ];

in

{ name = "fcgiwrap";
  meta = with pkgs.stdenv.lib.maintainers;
  { maintainers = [ fpletz ]; };

  nodes = {
    working = mkServer {
      services.fcgiwrap.socketGroup = "nginx";
    };

    permissionfail = mkServer {
      services.fcgiwrap.socketGroup = "root";
    };
  };

  testScript = { nodes, ... }: let
    permissionfail = nodes.permissionfail.config.system.build.toplevel;
  in ''
    $working->start;

    $working->waitForUnit("nginx");
    $working->waitForOpenPort("80");
    $working->succeed("curl http://localhost/ | tee /dev/stderr | grep 'Hello World!'");

    $working->succeed("${permissionfail}/bin/switch-to-configuration test");
    $working->fail("curl -f http://localhost/");
  '';
})
