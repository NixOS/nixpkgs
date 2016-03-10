{ ... }:

{

  imports = [
     ./influxdb011.nix
     ./percona.nix
     ./sensu/api.nix
     ./sensu/client.nix
     ./sensu/server.nix
     ./sensu/uchiwa.nix
    ];

}
