{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ananicy;
  configFile = pkgs.writeText "ananicy.conf" (lib.generators.toKeyValue { } cfg.settings);
  extraRules = pkgs.writeText "extraRules" (
    lib.concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraRules
  );
  extraTypes = pkgs.writeText "extraTypes" (
    lib.concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraTypes
  );
  extraCgroups = pkgs.writeText "extraCgroups" (
    lib.concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.extraCgroups
  );
  servicename =
    if ((lib.getName cfg.package) == (lib.getName pkgs.ananicy-cpp)) then "ananicy-cpp" else "ananicy";
  # Ananicy-CPP with BPF is not supported on hardened kernels https://github.com/NixOS/nixpkgs/issues/327382
  finalPackage =
    if (servicename == "ananicy-cpp" && config.boot.kernelPackages.isHardened) then
      (cfg.package { withBpf = false; })
    else
      cfg.package;
in
{
  options.services.ananicy = {
    enable = lib.mkEnableOption "Ananicy, an auto nice daemon";

    package = lib.mkPackageOption pkgs "ananicy" { example = "ananicy-cpp"; };

    rulesProvider = lib.mkPackageOption pkgs "ananicy" { example = "ananicy-cpp"; } // {
      description = ''
        Which package to copy default rules,types,cgroups from.
      '';
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          int
          bool
          str
        ]);
      default = { };
      example = {
        apply_nice = false;
      };
      description = ''
        See <https://github.com/Nefelim4ag/Ananicy/blob/master/ananicy.d/ananicy.conf>
      '';
    };

    extraRules = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [ ];
      description = ''
        Rules to write in 'nixRules.rules'. See:
        <https://github.com/Nefelim4ag/Ananicy#configuration>
        <https://gitlab.com/ananicy-cpp/ananicy-cpp/#global-configuration>
      '';
      example = [
        {
          name = "eog";
          type = "Image-Viewer";
        }
        {
          name = "fdupes";
          type = "BG_CPUIO";
        }
      ];
    };
    extraTypes = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [ ];
      description = ''
        Types to write in 'nixTypes.types'. See:
        <https://gitlab.com/ananicy-cpp/ananicy-cpp/#types>
      '';
      example = [
        {
          type = "my_type";
          nice = 19;
          other_parameter = "value";
        }
        {
          type = "compiler";
          nice = 19;
          sched = "batch";
          ioclass = "idle";
        }
      ];
    };
    extraCgroups = lib.mkOption {
      type = with lib.types; listOf attrs;
      default = [ ];
      description = ''
        Cgroups to write in 'nixCgroups.cgroups'. See:
        <https://gitlab.com/ananicy-cpp/ananicy-cpp/#cgroups>
      '';
      example = [
        {
          cgroup = "cpu80";
          CPUQuota = 80;
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ finalPackage ];
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
        ${lib.optionalString (cfg.extraRules != [ ]) "cp ${extraRules} $out/nixRules.rules"}
        ${lib.optionalString (cfg.extraTypes != [ ]) "cp ${extraTypes} $out/nixTypes.types"}
        ${lib.optionalString (cfg.extraCgroups != [ ]) "cp ${extraCgroups} $out/nixCgroups.cgroups"}
      '';
    };

    # ananicy and ananicy-cpp have different default settings
    services.ananicy.settings =
      let
        mkOD = lib.mkOptionDefault;
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
      }
      // (
        if servicename == "ananicy-cpp" then
          {
            # https://gitlab.com/ananicy-cpp/ananicy-cpp/-/blob/master/src/config.cpp#L12
            loglevel = mkOD "warn"; # default is info but its spammy
            cgroup_realtime_workaround = true;
            log_applied_rule = mkOD false;
          }
        else
          {
            # https://github.com/Nefelim4ag/Ananicy/blob/master/ananicy.d/ananicy.conf
            check_disks_schedulers = mkOD true;
            check_freq = mkOD 5;
          }
      );

    systemd = {
      packages = [ finalPackage ];
      services."${servicename}" = {
        wantedBy = [ "default.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ artturin ];
}
