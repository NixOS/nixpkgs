{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ferm;

  configFile = pkgs.stdenv.mkDerivation {
    name = "ferm.conf";
    text = cfg.config;
    preferLocalBuild = true;
    buildCommand = ''
      echo -n "$text" > $out
      ${cfg.package}/bin/ferm --noexec $out
    '';
  };
in {
  options = {
    services.ferm = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable Ferm Firewall.
          *Warning*: Enabling this service WILL disable the existing NixOS
          firewall! Default firewall rules provided by packages are not
          considered at the moment.
        '';
      };
      config = mkOption {
        description = "Verbatim ferm.conf configuration.";
        default = "";
        defaultText = "empty firewall, allows any traffic";
        type = types.lines;
      };
      package = mkOption {
        description = "The ferm package.";
        type = types.package;
        default = pkgs.ferm;
        defaultText = "pkgs.ferm";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.firewall.enable = false;
    systemd.services.ferm = {
      description = "Ferm Firewall";
      after = [ "ipset.target" ];
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = {
        Type="oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${cfg.package}/bin/ferm ${configFile}";
        ExecReload = "${cfg.package}/bin/ferm ${configFile}";
        ExecStop = "${cfg.package}/bin/ferm -F ${configFile}";
      };
    };
  };
}
