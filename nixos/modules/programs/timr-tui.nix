{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.timr-tui;

  timr-tui-sound = pkgs.timr-tui.override (
    prev:
    prev
    // {
      enableSound = true;
    }
  );
  timr-tui-sound-wrapped = pkgs.writeShellScriptBin "timr-tui" ''
    ${lib.getExe timr-tui-sound} --sound ${cfg.soundFile} "$@"
  '';

  timr-tui = if cfg.enableSound then timr-tui-sound-wrapped else pkgs.timr-tui;
in
{
  meta.maintainers = [ lib.maintainers.serhao ];
  options.programs.timr-tui = {
    enable = lib.mkEnableOption "timr-tui, a cli timr / pomodoro tool";
    enableSound = lib.mkEnableOption ''
      Enable sound notification when a timer end, this will wrap the timr command
      with the --sound <programs.timr-tui.soundFile> flag.
    '';
    soundFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file to play when a timer reach the end,
        and the `programs.timr-tui.enableSound` option is enabled.
        The provided file must be in .mp3 or .wav format.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      timr-tui
    ];
  };
}
