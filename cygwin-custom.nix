{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./cygwin-system.nix
  ];

  environment.systemPackages = [ pkgs.rsync ];

  nix = {
    extraOptions = ''
      secret-key-files = /var/store-key
    '';
  };
}
