{ config, pkgs, lib, ... }: with config;

{

  imports =
    [
     ./compat.nix
     ./dovecot.nix
     ./generic.nix
     ./haproxy.nix
     ./mysql.nix
     ./nginx.nix
     ./postgresql93.nix
     ./varnish.nix
    ];



}
