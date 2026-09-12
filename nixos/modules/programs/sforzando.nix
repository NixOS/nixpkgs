{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sforzando;
in
{
  options.programs.sforzando = {
    enable = lib.mkEnableOption "sforzando, a free SFZ 2.0 sample player by Plogue";

    createSymlinks = lib.mkEnableOption ''
      system-level symlinks required for sforzando's VST3/CLAP plugins.
      Enable this alongside the home-manager module when you do not want a
      system-wide install but still need VST3/CLAP support in a DAW
    '';
  };

  config = lib.mkIf (cfg.enable || cfg.createSymlinks) {
    # sforzando's VST3/CLAP plugins dlopen "/opt/Plogue/Aria/libAria.so" as a
    # hardcoded string — autoPatchelf can't fix string constants. Symlink the
    # Plogue tree from the nix store so the path resolves without a manual install.
    systemd.tmpfiles.rules = [
      "d /opt 0755 root root - -"
      "L+ /opt/Plogue - - - - ${pkgs.sforzando}/Plogue"
      # Plogue hardcodes access("/usr/bin/zenity") — ignores PATH entirely.
      "L+ /usr/bin/zenity - - - - ${pkgs.zenity}/bin/zenity"
    ];

    # zenity provides the dialog Plogue products need for license acceptance;
    # works on KDE, GNOME, and any other desktop.
    environment.systemPackages = lib.mkIf cfg.enable [
      pkgs.sforzando
      pkgs.zenity
    ];
  };
}
