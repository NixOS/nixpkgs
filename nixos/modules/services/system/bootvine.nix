{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bootvine;

  bootvineExe = lib.getExe cfg.package;
  settingsFormat = pkgs.formats.toml { };

  configFile =
    let
      uncheckedConfigFile = settingsFormat.generate "bootvine-unchecked.toml" cfg.settings;
      configChecker =
        if cfg.package == pkgs.bootvine then
          pkgs.buildPackages.bootvine # works in cross-compilation scenarios
        else if pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform then
          cfg.package # only works in non-cross-compilation scenarios
        else
          null;
    in
    if configChecker != null then
      pkgs.runCommand "bootvine.toml" { } ''
        ${lib.getExe configChecker} check ${uncheckedConfigFile}
        cp ${uncheckedConfigFile} $out
      ''
    else
      uncheckedConfigFile;

  configArgs = lib.optionalString (cfg.settings != { }) "--config ${configFile}";

  # Draws on its own virtual terminal and switches the console to it.
  consoleServiceConfig = {
    Type = "simple";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYPath = "/dev/tty12";
    TTYReset = true;
    TTYVTDisallocate = false;
  };

  bootService = {
    description = "Live dependency tree of boot jobs";
    wantedBy = [ "sysinit.target" ];
    before = [
      "display-manager.service"
      "shutdown.target"
    ];
    conflicts = [ "shutdown.target" ];
    unitConfig = {
      DefaultDependencies = false;
      IgnoreOnIsolate = true;
    };
    serviceConfig = consoleServiceConfig // {
      # bootvine starts in the initrd and keeps running in the real root.
      # When leaving the initrd, systemd kills all remaining processes except
      # those whose argv[0] starts with `@`. `ExecStart=@<path> <argv0> ...`
      # is how systemd sets argv[0], so this runs bootvine as `@bootvine`.
      ExecStart = "@${bootvineExe} @bootvine ${configArgs}";
    };
  };
in
{
  options.services.bootvine = {
    enable = lib.mkEnableOption ''
      bootvine, a live dependency tree of systemd jobs on the boot console,
      similar to nix-output-monitor for nix builds.
      It starts in the initrd and survives the switch to the real root. It
      hands the console back once the display manager switches to its
      terminal or the default target is reached, and comes back for shutdown
      until systemd hands over to systemd-shutdown
    '';

    package = lib.mkPackageOption pkgs "bootvine" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = {
        colors.tree.running-marker = "light-yellow";
        timing.keep-final-frame-for = "500ms";
      };
      description = ''
        Configuration for bootvine. `bootvine defaults --format nix` prints
        every key with its default. The build fails if `bootvine check`
        rejects the result (disabled if cfg.package is non-default and
        cross-compiling).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      bootvine = bootService;

      bootvine-shutdown = {
        description = "Live dependency tree of shutdown jobs";
        wantedBy = [ "shutdown.target" ];
        after = [
          "bootvine.service"
          "display-manager.service"
        ];
        unitConfig.DefaultDependencies = false;
        serviceConfig = consoleServiceConfig // {
          ExecStart = "${bootvineExe} --shutdown ${configArgs}";
        };
      };
    };

    boot.initrd.systemd = {
      storePaths = [ bootvineExe ] ++ lib.optional (cfg.settings != { }) configFile;

      services = {
        bootvine = bootService;

        systemd-hibernate-resume = {
          after = [ "systemd-vconsole-setup.service" ];
          serviceConfig = {
            ExecStartPre = "-${bootvineExe} open-resume-console";
            ExecStopPost = "-${bootvineExe} close-resume-console";
          };
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    tfc
    wvhulle
  ];
}
