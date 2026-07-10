{ lib, pkgs, ... }:
let
  tokenFile = toString (pkgs.writeText "syncthing-relay-token" "private_token");
in
{
  name = "syncthing-private-relay";
  meta.maintainers = with lib.maintainers; [ Sighery ];

  nodes.machine = {
    environment.systemPackages = [ pkgs.jq ];
    services.syncthing.relay = {
      enable = true;
      providedBy = "nixos-test";
      pools = [ ]; # Don't connect to any pool while testing.
      port = 12345;
      statusListenAddress = null;
      statusPort = null;
      token = tokenFile;
      extraOptions = [ "-debug" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("syncthing-relay.service")
    machine.wait_for_open_port(12345)

    machine.succeed(
      'journalctl -u syncthing-relay -e | grep -q -v "statusAddr="'
    )
    machine.succeed(
      "grep -qF 'LoadCredential=token:${tokenFile}' /etc/systemd/system/syncthing-relay.service"
    )
  '';
}
