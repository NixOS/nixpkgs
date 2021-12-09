{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.postgresql;

  cmd = pkgs.writeScriptBin "postgresql-cmd" ''
    #!${pkgs.runtimeShell}
    set -eux
    ${cfg.preStartCommands}
    (export MAINPID=1; ${cfg.postStartCommands}) &
    exec postgres
  '';
in

{
  imports = [
    ./postgresql.nix
    ../../config/environment-variables.nix
    ../../config/binsh.nix
  ];
  config = {
    environment.variables.PGDATA = cfg.dataDir;
    environment.systemPackages = [
      cfg.postgresqlWithExtraPlugins
      pkgs.busybox
      cmd
    ];
    services.postgresql.enable = true;
    services.postgresql.enableTCPIP = true;
  };
}
