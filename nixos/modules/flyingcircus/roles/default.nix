{ config, pkgs, lib, ... }: with config;

{

  imports =
    [
     ./compat.nix
     ./haproxy.nix
     ./mysql.nix
     ./nginx.nix
     ./postgresql.nix
     ./varnish.nix
    ];


}
