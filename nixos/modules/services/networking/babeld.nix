{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.babeld;

  paramsString = params:
    concatMapStringsSep "" (name: "${name} ${boolToString (getAttr name params)}")
                   (attrNames params);

  interfaceConfig = name:
    let
      interface = getAttr name cfg.interfaces;
    in
    "interface ${name} ${paramsString interface}\n";

  configFile = with cfg; pkgs.writeText "babeld.conf" (
    (optionalString (cfg.interfaceDefaults != null) ''
      default ${paramsString cfg.interfaceDefaults}
    '')
    + (concatMapStrings interfaceConfig (attrNames cfg.interfaces))
    + extraConfig);

in

{

  ###### interface

  options = {

    services.babeld = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the babeld network routing daemon.
        '';
      };

      interfaceDefaults = mkOption {
        default = null;
        description = ''
          A set describing default parameters for babeld interfaces.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for options.
        '';
        type = types.nullOr (types.attrsOf types.unspecified);
        example =
          {
            wired = true;
            "split-horizon" = true;
          };
      };

      interfaces = mkOption {
        default = {};
        description = ''
          A set describing babeld interfaces.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for options.
        '';
        type = types.attrsOf (types.attrsOf types.unspecified);
        example =
          { enp0s2 =
            { wired = true;
              "hello-interval" = 5;
              "split-horizon" = "auto";
            };
          };
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Options that will be copied to babeld.conf.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for details.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.babeld.enable {

    systemd.services.babeld = {
      description = "Babel routing daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.babeld}/bin/babeld -c ${configFile}";
    };

  };

}
