{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ananicy;
  configFile = pkgs.writeText "ananicy.conf" (generators.toKeyValue { } cfg.settings);
  extraRules = pkgs.writeText "extraRules" cfg.extraRules;
  servicename = if ((lib.getName cfg.package) == (lib.getName pkgs.ananicy-cpp)) then "ananicy-cpp" else "ananicy";
in
{
  options = {
    services.ananicy = {
      enable = mkEnableOption "Ananicy, an auto nice daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.ananicy;
        defaultText = literalExpression "pkgs.ananicy";
        example = literalExpression "pkgs.ananicy-cpp";
        description = lib.mdDoc ''
          Which ananicy package to use.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ int bool str ]);
        default = { };
        example = {
          apply_nice = false;
        };
        description = lib.mdDoc ''
          See <https://github.com/Nefelim4ag/Ananicy/blob/master/ananicy.d/ananicy.conf>
        '';
      };

      extraRules = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          Extra rules in json format on separate lines. See:
          <https://github.com/Nefelim4ag/Ananicy#configuration>
          <https://gitlab.com/ananicy-cpp/ananicy-cpp/#global-configuration>
        '';
        example = literalExpression ''
          '''
            { "name": "eog", "type": "Image-View" }
            { "name": "fdupes", "type": "BG_CPUIO" }
          '''
        '';

      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."ananicy.d".source = pkgs.runCommandLocal "ananicyfiles" { } ''
        mkdir -p $out
        # ananicy-cpp does not include rules or settings on purpose
        cp -r ${pkgs.ananicy}/etc/ananicy.d/* $out
        rm $out/ananicy.conf
        cp ${configFile} $out/ananicy.conf
        ${optionalString (cfg.extraRules != "") "cp ${extraRules} $out/nixRules.rules"}
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
