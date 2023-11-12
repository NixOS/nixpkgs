# A NixOS configuration
{ pkgs, ... }: {

  environment.systemPackages = [ pkgs.hello ]; # Truly NixOS

  services.abstract."serve-nix-manual" = {
    imports = [ ./generic-python-http-server.nix ];
    # You could change the port, but the default is sweet
    # service.port = 8080;
    service.directory = pkgs.nix.doc;
  };

  # A service that's distributed with NixOS may look like this.
  # Doesn't exists yet. Add to specialArgs in a submoduleWith.
  #
  # services.abstract."serve-nixpkgs-manual" = { serviceModules, ... }: {
  #   imports = [ serviceModules.nginx ];
  #   service.virtualHosts."/" = {
  #     root = pkgs.nix.doc;
  #   };
  # };

}