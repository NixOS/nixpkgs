{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.intel-lpmd;

  perStateOptional = elem: if (elem != null) then elem else "-1";
  xmlOptionalBool = elem: if elem then "1" else "0";

  perStateGenerator =
    cfg:
    lib.concatStringsSep "\n" (
      lib.forEach cfg (attr: ''
        <State>
          <ID>${attr.ID}</ID>
          <Name>${attr.Name}</Name>
          <EntrySystemLoadThres>${attr.EntrySystemLoadThres}</EntrySystemLoadThres>
          <EnterCPULoadThres>${attr.EnterCPULoadThres}</EnterCPULoadThres>
          <WLTType>${attr.WLTType}</WLTType>
          <ActiveCPUs>${attr.ActiveCPUs}</ActiveCPUs>
          <EPP>${perStateOptional attr.EPP}</EPP>
          <EPB>${perStateOptional attr.EPB}</EPB>
          <ITMTState>${perStateOptional attr.ITMTState}</ITMTState>
          <IRQMigrate>${perStateOptional attr.IRQMigrate}</IRQMigrate>
          <MinPollInterval>${attr.MinPollInterval}</MinPollInterval>
          ${
            lib.optionalString (
              attr.MaxPollInterval != null
            ) "<MaxPollInterval>${attr.MaxPollInterval}</MaxPollInterval>"
          }
          <PollIntervalIncrement>${perStateOptional attr.PollIntervalIncrement}</PollIntervalIncrement>
        </State>
      '')
    );

  statesGenerator =
    cfg:
    lib.concatStringsSep "\n" (
      lib.forEach cfg (attr: ''
        <States>
        <CPUFamily>${attr.CPUFamily}</CPUFamily>
        <CPUModel>${attr.CPUModel}</CPUModel>
        <CPUConfig>${attr.CPUConfig}</CPUConfig>
        ${perStateGenerator attr.State}
        </States>
      '')
    );

  xmlGenerator =
    cfg:
    lib.concatStringsSep "\n" (
      lib.forEach cfg (attr: ''
        <?xml version="1.0"?>
        <Configuration>
          ${
            lib.optionalString (attr.lp_mode_cpus != null) "<lp_mode_cpus>${attr.lp_mode_cpus}</lp_mode_cpus>"
          }
          <Mode>${attr.Mode}</Mode>
          <PerformanceDef>${attr.PerformanceDef}</PerformanceDef>
          <BalancedDef>${attr.BalancedDef}</BalancedDef>
          <PowersaverDef>${attr.PowersaverDef}</PowersaverDef>
          <HfiLpmEnable>${xmlOptionalBool attr.HfiLpmEable}</HfiLpmEnable>
          <HfiSuvEnable>${xmlOptionalBool attr.HfiSuvEnable}</HfiSuvEnable>
          <WLTHintEnable>${xmlOptionalBool attr.WLTHintEnable}</WLTHintEnable>
          <WLTProxyEnable>${xmlOptionalBool attr.WLTProxyEnable}</WLTProxyEnable>
          <util_entry_threshold>${attr.util_entry_threshold}</util_entry_threshold>
          <util_exit_threshold>${attr.util_exit_threshold}</util_exit_threshold>
          <EntryDelayMS>${attr.EntryDelayMS}</EntryDelayMS>
          <ExitDelayMS>${attr.ExitDelayMS}</ExitDelayMS>
          <EntryHystMS>${attr.EntryHystMS}</EntryHystMS>
          <ExitHystMS>${attr.ExitHystMS}</ExitHystMS>
          ${lib.optionalString (attr.lp_mode_epp != null) "<lp_mode_epp>${attr.lp_mode_epp}</lp_mode_epp>"}
          <IgnoreITMT>${xmlOptionalBool attr.IgnoreITMT}</IgnoreITMT>
          ${statesGenerator attr.States}
        </Configuration>
      '')
    );

  # TODO: more available in src/lpmd_config.c, lacking documentation
  perStateSubmodule = {
    options = {
      ID = lib.mkOption {
        description = ''
          A unique ID for the state.
        '';

        type = with lib.types; int.unsigned;
      };

      Name = lib.mkOption {
        description = ''
          A name for the state.
        '';

        type = with lib.types; str;
      };

      EntrySystemLoadThres = lib.mkOption {
        description = ''
          System entry load threshold (in %). To enter this state,
          system utilization must be less than or equal to this value.
        '';

        type = with lib.types; numbers.between 0 100;
      };

      EnterCPULoadThres = lib.mkOption {
        description = ''
          CPU entry load threshold (in %). To enter this state,
          active CPU utilization must be less than or equal to this value.
        '';

        type = with lib.types; numbers.between 0 100;
      };

      WLTType = lib.mkOption {
        description = ''
          Workload type value to enter into this state. This will not work
          without `WLTHintEnable`.
        '';

        type = with lib.types; int.unsigned; # TODO: range unclear
      };

      ActiveCPUs = lib.mkOption {
        default = null;
        description = ''
          Active CPUs in this state. Leave as `null` to use all CPUs.

          Can be specified as comma separating string,
          or as a range by using '-'.
        '';

        type = with lib.types; nullOr str;
      };

      EPP = lib.mkOption {
        default = null;
        description = ''
          EPP (energy performance preferences) to use for this state.
          Leave as `null` to ignore this setting.

          Accepts a value from **0** (favor performance)
          to **255** (favor power).
        '';

        type = with lib.types; nullOr numbers.between 0 255;
      };

      EPB = lib.mkOption {
        default = null;
        description = ''
          EPB (energy performance and bias) to apply for this state.
          Leave as `null` to ignore this setting.

          Accepts a value from **0** (highest performance)
          to **15** (highest energy savings).
        '';

        type = with lib.types; nullOr numbers.between 0 15;
      };

      ITMTState = lib.mkOption {
        default = null;
        description = ''
          Set the state of ITMT flag.
          Leave as `null` to ignore.
        '';

        type = with lib.types; nullOr int.unsigned; # TODO: range unclear
      };

      IRQMigrate = lib.mkOption {
        default = null;
        description = ''
          Migrate IRQs to the active CPUs in thi state.
          Leave as `null` to ignore.
        '';

        type = with lib.types; nullOr int.unsigned; # TODO: range unclear
      };

      MinPollInterval = lib.mkOption {
        description = ''
          The minimum polling interval (in ms).
        '';

        type = with lib.types; int.unsigned;
      };

      MaxPollInterval = lib.mkOptional {
        default = null;
        description = ''
          The maximum polling interval (in ms).
          Leave as `null` to enforce no maximum.
        '';

        type = with lib.types; nullOr int.unsigned;
      };

      PollIntervalIncrement = lib.mkOption {
        default = null;
        description = ''
          The polling interval increment (in ms).
          Leave as `null` to let the daemon configure this based on CPU utilization.
        '';

        type = with lib.types; nullOr int.unsigned;
      };
    };
  };

  statesSubmodule = {
    options = {
      CPUFamily = lib.mkOption {
        description = ''
          The CPU generation to match.
        '';

        type = with lib.types; str;
      };

      CPUModel = lib.mkOption {
        description = ''
          The CPU model to match.
        '';

        type = with lib.types; str;
      };

      CPUConfig = lib.mkOption {
        description = ''
          Define a configuration of CPUs and TDP to match different skews
          for the same CPU model and family.

          See `man 5 intel_lpmd_config.xml` for more details.
        '';

        type = with lib.types; str;
      };

      State = lib.mkOption {
        default = [ ];
        description = ''
          List of "state" definitions.
        '';

        type = with lib.types; listOf (submodule perStateSubmodule);
      };
    };
  };

  xmlSubmodule = {
    options = {
      lp_mode_cpus = lib.mkOption {
        default = null;
        description = ''
          The set of active CPUs when in LPM (low power mode).
          Leave as `null` to let the daemon auto-detect this.

          Can be specified as comma separating string, or as a range by using
          '..' or '-'.
        '';

        example = "1,2,4..6,8-10";

        type = with lib.types; nullOr str;
      };

      Mode = lib.mkOption {
        default = "0";
        description = ''
          Specifies the way to migrate tasks to active CPUs
          when LPM is active.

          - '0': set *cpuset* to the active CPUs for cgroup v2 based systemd
          - '1': isolate non-LPM CPUs so tasks are scheduled for LPM CPUs only
          - '2': force idle injection to non-LPM CPUs and let scheduler handle LPM CPUs
        '';

        type =
          with lib.types;
          enum [
            "0"
            "1"
            "2"
          ];
      };

      PerformanceDef = lib.mkOption {
        default = "-1";
        description = ''
          Specifies the default behaviour when the power setting
          is set to **Performance**.

          - '-1': never enter LPM
          - '0': opportunistic LPM enter/exit based of HFI/Util request
          - '1': always stay in LPM
        '';

        type =
          with lib.types;
          enum [
            "-1"
            "0"
            "1"
          ];
      };

      BalancedDef = lib.mkOption {
        default = "-1";
        description = ''
          Specifies the default behaviour when the power setting
          is set to **Balanced**.

          - '-1': never enter LPM
          - '0': opportunistic LPM enter/exit based of HFI/Util request
          - '1': always stay in LPM
        '';

        type =
          with lib.types;
          enum [
            "-1"
            "0"
            "1"
          ];
      };

      PowersaverDef = lib.mkOption {
        default = "-1";
        description = ''
          Specifies the default behaviour when the power setting
          is set to **Power saver**.

          - '-1': never enter LPM
          - '0': opportunistic LPM enter/exit based of HFI/Util request
          - '1': always stay in LPM
        '';

        type =
          with lib.types;
          enum [
            "-1"
            "0"
            "1"
          ];
      };

      HfiLpmEnable = {
        default = false;
        description = ''
          Specifies if the HFI monitor can capture HFI hints for LPM.
        '';

        type = with lib.types; bool;
      };

      HfiSuvEnable = {
        default = false;
        description = ''
          Specifies if the HFI monitor can capture HFI hints for survivability mode.
        '';

        type = with lib.types; bool;
      };

      WLTHintEnable = lib.mkOption {
        default = false;
        description = ''
          Enable use of hardware workload type hints.
        '';

        type = with lib.types; bool;
      };

      WLTProxyEnable = lib.mkOption {
        default = false;
        description = ''
          Enable use of proxy workload type hints.
        '';

        type = with lib.types; bool;
      };

      util_entry_threshold = lib.mkOption {
        default = 10;
        description = ''
          Specifices the system utilization threshold (in %) for entering LPM.
          Set both this and `util_exit_threshold` to '0' to disable this feature.
        '';

        type = with lib.types; numbers.between 0 100;
      };

      util_exit_threshold = lib.mkOption {
        default = 95;
        description = ''
          Specifices the system utilization threshold (in %) for exiting LPM.
          Set both this and `util_entry_threshold` to '0' to disable this feature.
        '';

        type = with lib.types; numbers.between 0 100;
      };

      EntryDelayMS = lib.mkOption {
        default = 0;
        description = ''
          Specifies the sample interval (in ms) used by the utilization monitor
          when system wants to enter LPM.

          Setting this to '0' uses the default interval of 1000ms.
        '';

        type = with lib.types; ints.unsigned;
      };

      ExitDelayMS = lib.mkOption {
        default = 0;
        description = ''
          Specifies the sample interval (in ms) used by the utilization monitor
          when system wants to exit LPM.

          Setting this to '0' uses an adaptive value which is calculated based
          on CPU utilization.
        '';

        type = with lib.types; ints.unsigned;
      };

      # TODO: it is unclear if disabling requires both to be set to '0' or not.
      EntryHystMS = lib.mkOption {
        default = "0";
        description = ''
          Specifies a hysteresis threshold (in ms) when the system is in LPM.
          When the previous average time **stayed in** LPM is lower than this
          value, the **current enter** LPM request will be ignored, due to the
          expectation of the system exiting LPM soon.

          Setting this to '0' disables the hysteresis algorithm.
        '';

        type = with lib.types; ints.unsigned;
      };

      ExitHystMS = lib.mkOption {
        default = "0";
        description = ''
          Specifies a hysteresis threshold (in ms) when the system is not in LPM.
          When the previous average time **stayed out of** LPM is lower than this
          value, the **current exit** LPM request will be ignored, due to the
          expectation of the system entering LPM soon.

          Setting this to '0' disables the hysteresis algorithm.
        '';

        type = with lib.types; ints.unsigned;
      };

      lp_mode_epp = lib.mkOption {
        default = null;
        description = ''
          EPP (energy performance preferences) to use in LPM.
          Leave as `null` to ignore this setting.

          Accepts a value from **0** (favor performance)
          to **255** (favor power).
        '';

        type = with lib.types; nullOr numbers.between 0 255;
      };

      IgnoreITMT = lib.mkOption {
        default = false;
        description = ''
          Specifies whether to avoid changing the scheduler ITMT flag.

          If enabled, ITMT is disabled upon entering LPM,
          and re-enabled upon exiting LPM. Otherwise, the
          ITMT setting is ignored entirely.
        '';
      };

      States = lib.mkOption {
        default = [ ];
        description = ''
          List of per-platform low power states.
        '';

        type = with lib.types; listOf (submodule statesSubmodule);
      };
    };
  };
in
{
  ###### interface
  options = {
    services.intel-lpmd = {
      enable = lib.mkEnableOption "Intel's low power mode daemon";
      package = lib.mkPackageOption pkgs "intel-lpmd";

      settings = lib.mkOption {
        default = { };
        description = ''
          Configuration for the daemon, written to `/etc/intel_lpmd`.
          See `man 5 intel_lpmd_config.xml` for available configuration.
        '';

        type = with lib.types; attrsOf (submodule xmlSubmodule);
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment = {
      etc."/etc/intel_lpmd/intel_lpmd_config.xml".text = xmlGenerator cfg;
      systemPackages = [ cfg.package ];
    };

    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
  };
}
