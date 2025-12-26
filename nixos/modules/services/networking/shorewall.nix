{
  config,
  lib,
  pkgs,
  ...
}:
let
  types = lib.types;
  cfg = config.services.shorewall;
in
{
  options = {
    services.shorewall = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Shorewall IPv4 Firewall.

          ::: {.warning}
          Enabling this service WILL disable the existing NixOS
          firewall! Default firewall rules provided by packages are not
          considered at the moment.
          :::
        '';
      };
      package = lib.mkPackageOption pkgs "shorewall" { };
      configs = lib.mkOption {
        type = types.attrsOf types.lines;
        default = { };
        description = ''
          This option defines the Shorewall configs.
          The attribute name defines the name of the config,
          and the attribute value defines the content of the config.
        '';
        apply = lib.mapAttrs (name: text: pkgs.writeText "${name}" text);
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.firewall.enable = false;
    systemd.services.shorewall = {
      description = "Shorewall IPv4 Firewall";
      after = [ "ipset.target" ];
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      restartTriggers = lib.attrValues cfg.configs;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${cfg.package}/bin/shorewall start";
        ExecReload = "${cfg.package}/bin/shorewall reload";
        ExecStop = "${cfg.package}/bin/shorewall stop";
      };
      preStart = ''
        install -D -d -m 750 /var/lib/shorewall
        install -D -d -m 755 /var/lock/subsys
        touch                /var/log/shorewall.log
        chmod 750            /var/log/shorewall.log
      '';
    };
    environment = {
      etc = lib.mapAttrs' (
        name: conf: lib.nameValuePair "shorewall/${name}" { source = conf; }
      ) cfg.configs;
      systemPackages = [ cfg.package ];
    };
  };
}
