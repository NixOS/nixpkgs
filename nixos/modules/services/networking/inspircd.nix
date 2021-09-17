{ config, lib, pkgs, ... }:

let
  cfg = config.services.inspircd;

  configFile = pkgs.writeText "inspircd.conf" cfg.config;

in {
  meta = {
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  options = {
    services.inspircd = {
      enable = lib.mkEnableOption "InspIRCd";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.inspircd;
        defaultText = lib.literalExample "pkgs.inspircd";
        example = lib.literalExample "pkgs.inspircdMinimal";
        description = ''
          The InspIRCd package to use. This is mainly useful
          to specify an overridden version of the
          <literal>pkgs.inspircd</literal> dervivation, for
          example if you want to use a more minimal InspIRCd
          distribution with less modules enabled or with
          modules enabled which can't be distributed in binary
          form due to licensing issues.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Verbatim <literal>inspircd.conf</literal> file.
          For a list of options, consult the
          <link xlink:href="https://docs.inspircd.org/3/configuration/">InspIRCd documentation</link>, the
          <link xlink:href="https://docs.inspircd.org/3/modules/">Module documentation</link>
          and the example configuration files distributed
          with <literal>pkgs.inspircd.doc</literal>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.inspircd = {
      description = "InspIRCd - the stable, high-performance and modular Internet Relay Chat Daemon";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${lib.getBin cfg.package}/bin/inspircd start --config ${configFile} --nofork --nopid
        '';
        DynamicUser = true;
      };
    };
  };
}
