{ ... }:

{

  imports = [
     ./influxdb011.nix
     ./sensu/api.nix
     ./sensu/client.nix
     ./sensu/server.nix
     ./sensu/uchiwa.nix
    ];

}
