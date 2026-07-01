{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.kopia = {
    enable = lib.mkEnableOption "kopia, a fast and secure open-source backup/restore tool";

    package = lib.mkPackageOption pkgs "kopia" { };

    systemdProperties = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "Nice=10"
        "IOSchedulingClass=idle"
        "IOWeight=50"
        "CPUWeight=50"
      ];
      description = ''
        systemd service properties to apply to each kopia invocation, passed as
        `--property=` flags to {manpage}`systemd-run(1)`. See
        {manpage}`systemd.exec(5)` and {manpage}`systemd.resource-control(5)`
        for available properties.

        This requires systemd. Non-root invocations use the user manager
        (present in standard desktop and SSH logins, absent in some containers);
        root uses the system manager.
      '';
    };

    ui = {
      enable = lib.mkEnableOption "KopiaUI, the Electron-based GUI for kopia";

      package = lib.mkPackageOption pkgs "kopia-ui" { };
    };
  };

  config =
    let
      cfg = config.programs.kopia;
      needsWrapper = cfg.systemdProperties != [ ];
      kopiaFinal =
        if !needsWrapper then
          cfg.package
        else
          pkgs.symlinkJoin {
            name = "kopia-wrapped";
            meta.mainProgram = "kopia";
            paths = [
              (pkgs.writeShellScriptBin "kopia" ''
                # --pty gives kopia a real tty (colours, progress bars); --pipe lets
                # kopia detect non-interactive context when output is redirected.
                _sd_tty=--pipe
                [ -t 1 ] && _sd_tty=--pty

                # Root has no user manager; use the system manager instead.
                _sd_scope=--user
                [ "$(${pkgs.coreutils}/bin/id -u)" = "0" ] && _sd_scope=

                exec ${pkgs.systemd}/bin/systemd-run $_sd_scope --collect --quiet --same-dir --service-type=exec --wait "$_sd_tty" --unit="kopia-$$" \
                  ${lib.concatStringsSep " \\\n  " (map (p: "--property=${p}") cfg.systemdProperties)} \
                  -- ${lib.escapeShellArg "${cfg.package}/bin/kopia"} "$@"
              '')
              cfg.package # preserves completions, manpages, etc.
            ];
          };
    in
    lib.mkMerge [
      (lib.mkIf cfg.enable {
        environment.systemPackages = [ kopiaFinal ];
      })
      (lib.mkIf cfg.ui.enable {
        environment.systemPackages = [
          # Wrap rather than override kopia= to avoid rebuilding the electron app
          # every time wrapper options change.
          (
            if !needsWrapper then
              cfg.ui.package
            else
              pkgs.symlinkJoin {
                name = "kopia-ui-wrapped";
                nativeBuildInputs = [ pkgs.makeWrapper ];
                paths = [ cfg.ui.package ];
                postBuild = ''
                  wrapProgram $out/bin/kopia-ui \
                    --set-default KOPIA_EXECUTABLE ${lib.getExe kopiaFinal}
                '';
              }
          )
        ];
      })
    ];
}
