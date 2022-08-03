{ config, pkgs, lib, ... }:

with lib;

let

  cfg  = config.services.salt.minion;

  fullConfig = lib.recursiveUpdate {
    # Provide defaults for some directories to allow an immutable config dir
    # NOTE: the config dir being immutable prevents `minion_id` caching

    # Default is equivalent to /etc/salt/minion.d/*.conf
    default_include = "/var/lib/salt/minion.d/*.conf";
    # Default is in /etc/salt/pki/minion
    pki_dir = "/var/lib/salt/pki/minion";
  } cfg.configuration;

in

{
  options = {
    services.salt.minion = {
      enable = mkEnableOption "Salt minion service";
      configuration = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc ''
          Salt minion configuration as Nix attribute set.
          See <https://docs.saltstack.com/en/latest/ref/configuration/minion.html>
          for details.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      # Set this up in /etc/salt/minion so `salt-call`, etc. work.
      # The alternatives are
      # - passing --config-dir to all salt commands, not just the minion unit,
      # - setting aglobal environment variable.
      etc."salt/minion".source = pkgs.writeText "minion" (
        builtins.toJSON fullConfig
      );
      systemPackages = with pkgs; [ salt ];
    };
    systemd.services.salt-minion = {
      description = "Salt Minion";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [
        util-linux
      ];
      serviceConfig = {
        ExecStart = "${pkgs.salt}/bin/salt-minion";
        LimitNOFILE = 8192;
        Type = "notify";
        NotifyAccess = "all";
      };
      restartTriggers = [
        config.environment.etc."salt/minion".source
      ];
    };
  };
}

