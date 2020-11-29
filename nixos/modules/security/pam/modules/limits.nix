{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.limits;

  limitSubmodule = {
    options = {
      domain = mkOption {
        type = types.str;
      };
      type = mkOption {
        type = types.str;
      };
      item = mkOption {
        type = types.str;
      };
      value = mkOption {
        type = with types; oneOf [ str int ];
      };
    };
  };

  moduleOption = mkOption {
    type = with types; listOf (submodule limitSubmodule);
    default = [];
    description = ''
      Define resource limits that should apply to users or groups.
      Each item in the list should be an attribute set with a
      <varname>domain</varname>, <varname>type</varname>,
      <varname>item</varname>, and <varname>value</varname>
      attribute. The syntax and semantics of these attributes
      must be that described in the limits.conf(5) man page.

      Note that these limits do not apply to systemd services,
      whose limits can be changed via <option>systemd.extraConfig</option>
      instead.
    '';
  };

  makeLimitsConf = limits: pkgs.writeText "limits.conf"
    (concatMapStringsSep "\n" ({ domain, type, item, value }:
      "${domain} ${type} ${item} ${toString value}")
    limits);
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.limits = moduleOption;
            };

            config = {
              modules.limits = mkDefault cfg;

              session.limits = mkIf (config.modules.limits != []) {
                control = "required";
                path = "${pkgs.pam}/lib/security/pam_limits.so";
                args = [
                  "conf=${makeLimitsConf config.modules.limits}"
                ];
                order = 13000;
              };
            };
          })
        );
      };

      modules.limits = moduleOption;
    };
  };
}
