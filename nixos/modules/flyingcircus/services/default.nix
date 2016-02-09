{ ... }:

{

  imports = [
     ./sensu/api.nix
     ./sensu/server.nix
     ./sensu/client.nix
     ./sensu/uchiwa.nix
    ];

}
