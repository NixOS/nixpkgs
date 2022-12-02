{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let

  cfg = config.services.riemann-tools;

  riemannHost = "${cfg.riemannHost}";

  healthLauncher = writeScriptBin "riemann-health" ''
    #!/bin/sh
    exec ${pkgs.riemann-tools}/bin/riemann-health ${builtins.concatStringsSep " " cfg.extraArgs} --host ${riemannHost}
  '';


in {

  options = {

    services.riemann-tools = {
      enableHealth = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the riemann-health daemon.
        '';
      };
      riemannHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc ''
          Address of the host riemann node. Defaults to localhost.
        '';
      };
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          A list of commandline-switches forwarded to a riemann-tool.
          See for example `riemann-health --help` for available options.
        '';
        example = ["-p 5555" "--timeout=30" "--attribute=myattribute=42"];
      };
    };
  };

  config = mkIf cfg.enableHealth {

    users.groups.riemanntools.gid = config.ids.gids.riemanntools;

    users.users.riemanntools = {
      description = "riemann-tools daemon user";
      uid = config.ids.uids.riemanntools;
      group = "riemanntools";
    };

    systemd.services.riemann-health = {
      wantedBy = [ "multi-user.target" ];
      path = [ procps ];
      serviceConfig = {
        User = "riemanntools";
        ExecStart = "${healthLauncher}/bin/riemann-health";
      };
    };

  };

}
