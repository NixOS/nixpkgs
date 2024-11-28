{ config, lib, pkgs, ... }:
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
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Ferm Firewall.
          *Warning*: Enabling this service WILL disable the existing NixOS
          firewall! Default firewall rules provided by packages are not
          considered at the moment.
        '';
      };
      config = lib.mkOption {
        description = "Verbatim ferm.conf configuration.";
        default = "";
        defaultText = lib.literalMD "empty firewall, allows any traffic";
        type = lib.types.lines;
      };
      package = lib.mkPackageOption pkgs "ferm" { };
    };
  };

  config = lib.mkIf cfg.enable {
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
