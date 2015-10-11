{ config, pkgs, lib, ... }: with config;

{

  imports =
    [
     ./haproxy.nix
     ./mysql.nix
     ./nginx.nix
     ./postgresql.nix
     ./varnish.nix
    ];


}
