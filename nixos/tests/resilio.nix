import ./make-test-python.nix ({ pkgs, lib, ...}:
let
  user = "admin";
  password = "password";
  port = 10000;
in with lib; {
  name = "resilio";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ danieldk ];
  };

  nodes = {
    resilio = { config, pkgs, ... }: {
      services.resilio = {
        enable = true;
        enableWebUI = true;
        deviceName = "nixos-test";
        directoryRoot = "/tmp/resilio";
        httpListenPort = port;
        httpLogin = user;
        httpPass = password;
      };
    };
  };

  testScript = ''
    resilio.wait_for_unit("resilio")
    resilio.wait_for_open_port(${toString port})
    resilio.succeed("curl -i 'http://localhost:${toString port}/' | grep -q 'Location: /gui/'")
    resilio.succeed("curl --fail --user '${user}:${password}' http://localhost:${toString port}/gui/")
  '';
})
