{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ananicy;
  configFile = pkgs.writeText "ananicy.conf" (generators.toKeyValue { } cfg.settings);
  extraRules = pkgs.writeText "extraRules" (concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraRules);
  extraTypes = pkgs.writeText "extraTypes" (concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraTypes);
  extraCgroups = pkgs.writeText "extraCgroups" (concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraCgroups);
  servicename = if ((lib.getName cfg.package) == (lib.getName pkgs.ananicy-cpp)) then "ananicy-cpp" else "ananicy";
in
{
  options = {
    services.ananicy = {
      enable = mkEnableOption "Ananicy, an auto nice daemon";

      package = mkPackageOption pkgs "ananicy" {
        example = "ananicy-cpp";
      };

      rulesProvider = mkPackageOption pkgs "ananicy" {
        example = "ananicy-cpp";
      } // {
        description = ''
          Which package to copy default rules,types,cgroups from.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ int bool str ]);
        default = { };
        example = {
          apply_nice = false;
        };
        description = ''
          See <https://github.com/Nefelim4ag/Ananicy/blob/master/ananicy.d/ananicy.conf>
        '';
      };

      extraRules = mkOption {
        type = with types; listOf attrs;
        default = [ ];
        description = ''
          Rules to write in 'nixRules.rules'. See:
          <https://github.com/Nefelim4ag/Ananicy#configuration>
          <https://gitlab.com/ananicy-cpp/ananicy-cpp/#global-configuration>
        '';
        example = [
          { name = "eog"; type = "Image-Viewer"; }
          { name = "fdupes"; type = "BG_CPUIO"; }
        ];
      };
      extraTypes = mkOption {
        type = with types; listOf attrs;
        default = [ ];
        description = ''
          Types to write in 'nixTypes.types'. See:
          <https://gitlab.com/ananicy-cpp/ananicy-cpp/#types>
        '';
        example = [
          { type = "my_type"; nice = 19; other_parameter = "value"; }
          { type = "compiler"; nice = 19; sched = "batch"; ioclass = "idle"; }
        ];
      };
      extraCgroups = mkOption {
        type = with types; listOf attrs;
        default = [ ];
        description = ''
          Cgroups to write in 'nixCgroups.cgroups'. See:
          <https://gitlab.com/ananicy-cpp/ananicy-cpp/#cgroups>
        '';
        example = [
          { cgroup = "cpu80"; CPUQuota = 80; }
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."ananicy.d".source = pkgs.runCommandLocal "ananicyfiles" { } ''
        mkdir -p $out
        # ananicy-cpp does not include rules or settings on purpose
        if [[ -d "${cfg.rulesProvider}/etc/ananicy.d/00-default" ]]; then
          cp -r ${cfg.rulesProvider}/etc/ananicy.d/* $out
        else
          cp -r ${cfg.rulesProvider}/* $out
        fi

        # configured through .setings
        rm -f $out/ananicy.conf
        cp ${configFile} $out/ananicy.conf
        ${optionalString (cfg.extraRules != [ ]) "cp ${extraRules} $out/nixRules.rules"}
        ${optionalString (cfg.extraTypes != [ ]) "cp ${extraTypes} $out/nixTypes.types"}
        ${optionalString (cfg.extraCgroups != [ ]) "cp ${extraCgroups} $out/nixCgroups.cgroups"}
      '';
    };

    # ananicy and ananicy-cpp have different default settings
    services.ananicy.settings =
      let
        mkOD = mkOptionDefault;
      in
      {
        cgroup_load = mkOD true;
        type_load = mkOD true;
        rule_load = mkOD true;
        apply_nice = mkOD true;
        apply_ioclass = mkOD true;
        apply_ionice = mkOD true;
        apply_sched = mkOD true;
        apply_oom_score_adj = mkOD true;
        apply_cgroup = mkOD true;
      } // (if ((lib.getName cfg.package) == (lib.getName pkgs.ananicy-cpp)) then {
        # https://gitlab.com/ananicy-cpp/ananicy-cpp/-/blob/master/src/config.cpp#L12
        loglevel = mkOD "warn"; # default is info but its spammy
        cgroup_realtime_workaround = mkOD config.systemd.enableUnifiedCgroupHierarchy;
        log_applied_rule = mkOD false;
      } else {
        # https://github.com/Nefelim4ag/Ananicy/blob/master/ananicy.d/ananicy.conf
        check_disks_schedulers = mkOD true;
        check_freq = mkOD 5;
      });

    systemd = {
      # https://gitlab.com/ananicy-cpp/ananicy-cpp/#cgroups applies to both ananicy and -cpp
      enableUnifiedCgroupHierarchy = mkDefault false;
      packages = [ cfg.package ];
      services."${servicename}" = {
        wantedBy = [ "default.target" ];
      };
    };
  };

  meta = {
    maintainers = with maintainers; [ artturin ];
  };
}
