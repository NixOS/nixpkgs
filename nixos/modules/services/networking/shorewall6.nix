{
  config,
  lib,
  pkgs,
  ...
}:
let
  types = lib.types;
  cfg = config.services.shorewall6;
in
{
  options = {
    services.shorewall6 = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Shorewall IPv6 Firewall.

          ::: {.warning}
          Enabling this service WILL disable the existing NixOS
          firewall! Default firewall rules provided by packages are not
          considered at the moment.
          :::
        '';
      };
      package = lib.mkOption {
        type = types.package;
        default = pkgs.shorewall;
        defaultText = lib.literalExpression "pkgs.shorewall";
        description = "The shorewall package to use.";
      };
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
    systemd.services.shorewall6 = {
      description = "Shorewall IPv6 Firewall";
      after = [ "ipset.target" ];
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      restartTriggers = lib.attrValues cfg.configs;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${cfg.package}/bin/shorewall6 start";
        ExecReload = "${cfg.package}/bin/shorewall6 reload";
        ExecStop = "${cfg.package}/bin/shorewall6 stop";
      };
      preStart = ''
        install -D -d -m 750 /var/lib/shorewall6
        install -D -d -m 755 /var/lock/subsys
        touch                /var/log/shorewall6.log
        chown 750            /var/log/shorewall6.log
      '';
    };
    environment = {
      etc = lib.mapAttrs' (
        name: conf: lib.nameValuePair "shorewall6/${name}" { source = conf; }
      ) cfg.configs;
      systemPackages = [ cfg.package ];
    };
  };
}
