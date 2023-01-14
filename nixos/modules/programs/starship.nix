{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.starship;

  settingsFormat = pkgs.formats.toml { };

  settingsFileNixos = settingsFormat.generate "starship.toml" cfg.settings;

  settingsFileMerged = pkgs.runPythonScriptWith {
    name = "starship.toml";
    python = pkgs.python3.withPackages (pp: [
      pp.jsonmerge
      pp.toml
    ]);
  } ''
    from jsonmerge import merge
    import os
    import subprocess
    import toml
    import tempfile

    with tempfile.TemporaryDirectory() as tmpdir:
        preset = subprocess.check_output(
            ["${pkgs.starship}/bin/starship", "preset", "${cfg.preset}"],
            env={
                "HOME": tmpdir,
            },
            encoding="utf-8",
        )
    preset = toml.loads(preset)
    with open("${settingsFileNixos}") as settings_file:
        settings = toml.load(settings_file)
    merged = merge(preset, settings)
    with open(os.environ["out"], "w") as out:
        toml.dump(merged, out)
  '';

  settingsFile = if cfg.preset != null then settingsFileMerged else settingsFileNixos;

in {
  options.programs.starship = {
    enable = mkEnableOption (lib.mdDoc "the Starship shell prompt");

    preset = mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "pure-preset";
      description = lib.mdDoc ''
        A [configuration preset](https://starship.rs/presets/) to merge settings into.
      '';
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = lib.mdDoc ''
        Configuration included in `starship.toml`.

        See https://starship.rs/config/#prompt for documentation.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.bash.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init bash)"
      fi
    '';

    programs.fish.promptInit = ''
      if test "$TERM" != "dumb" -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = "vterm" \)
        set -x STARSHIP_CONFIG ${settingsFile}
        eval (${pkgs.starship}/bin/starship init fish)
      end
    '';

    programs.zsh.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
  };

  meta.maintainers = pkgs.starship.meta.maintainers;
}
