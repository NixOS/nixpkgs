{ config, lib, pkgs, ... }:

with lib;

let
    flavor_files =
        if builtins.pathExists /etc/nixos/vagrant.nix
        then [./vagrant.nix]
        else [./fcio.nix];

    get_enc = path: default:
        if builtins.pathExists path
        then builtins.fromJSON (builtins.readFile path)
        else default;

    enc =
        get_enc /etc/nixos/enc.json
        (get_enc /tmp/fc-data/enc.json {});
in
{
  imports =
    flavor_files ++
    [./user.nix
     ./roles/default.nix];

  networking.hostName = if enc ? name then enc.name else "default";

  users.motd = ''
      Welcome to the Flying Circus

      Support:   support@flyingcircus.io or +49 345 219401-0
      Status:    http://status.flyingcircus.io/
      Docs:      http://flyingcircus.io/doc/
      ChangeLog: http://flyingcircus.io/doc/reference/changes/XXX

      Hostname:  ${enc.name}    Environment: ${enc.parameters.environment}    Location:  ${enc.parameters.location}
      Services:  ${enc.parameters.service_description}

    '';

  environment.noXlibs = true;
  sound.enable = false;

  environment.systemPackages = [
      pkgs.cyrus_sasl
      pkgs.db
      pkgs.dstat
      pkgs.gcc
      pkgs.git
      pkgs.libxml2
      pkgs.libxslt
      pkgs.mercurial
      pkgs.openldap
      pkgs.openssl
      pkgs.python27Full
      pkgs.python27Packages.virtualenv
      pkgs.vim
      pkgs.zlib
  ];

  environment.pathsToLink = [ "/include" ];
  environment.shellInit = ''
   # help pip to find libz.so when building lxml
   export LIBRARY_PATH=/var/run/current-system/sw/lib
   # help dynamic loading like python-magic to find it's libraries
   export LD_LIBRARY_PATH=$LIBRARY_PATH
   # ditto for header files, e.g. sqlite
   export C_INCLUDE_PATH=/var/run/current-system/sw/include:/var/run/current-system/sw/include/sasl
  '';


  security.sudo.extraConfig =
      ''
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
      '';
}
