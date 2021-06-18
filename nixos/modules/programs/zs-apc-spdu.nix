{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zs-apc-spdu;

  hostOptions = {
    host = mkOption {
      type = types.str;
      description = "Set the hostname or IP address of host";
    };

    apc = mkOption {
      type = types.str;
      default = "";
      description = "Set the APC for this host";
    };

    outlets = mkOption {
      type = with types; listOf ints.u8;
      description = "Set the list of APC outlets which belong to this host";
    };
  };

  optSetApc = apc: optionalString (apc != "") "apc ${apc}\n";
  fmt_outlets = { outlets, ... }: concatStringsSep " " (builtins.map toString outlets);

in {
  meta.maintainers = with maintainers; [ zseri ];

  options.programs.zs-apc-spdu = {
    defaultApc = mkOption {
      type = types.str;
      default = "";
      description = ''
        Set the default APC for all hosts in the default config for
        <command>zs-apc-spdu-ctl</command>.
      '';
    };

    hosts = mkOption {
      type = with types; attrsOf (submodule { options = hostOptions; });
      default = {};
      description = ''
        Set the default map of hosts. If empty, no config will be generated.
        The key is the name which can be given to
        <command>zs-apc-spdu-ctl</command> on the command line.
      '';
    };
  };

  config = mkIf (cfg.hosts != {}) {
    environment.systemPackages = [ pkgs.zs-apc-spdu-ctl ];

    environment.etc."zs-apc-spdu.conf" = {
      text = (optSetApc cfg.defaultApc)
        + (concatStringsSep "\n\n"
            (mapAttrsToList (key: value: ''
              :${key}
              host ${value.host}
              ${optSetApc value.apc}outlets ${fmt_outlets value}
            '') cfg.hosts)
          );

      # may contain sensitive information
      # the user should set an appropriate group
      mode = mkDefault "0440";
      group = mkDefault "wheel";
    };
  };
}
