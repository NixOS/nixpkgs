{ config, lib, pkgs, ... }:

let
  cfg = config.programs.yazi;

  settingsFormat = pkgs.formats.toml { };

  names = [ "yazi" "theme" "keymap" ];

  bashSetCwd = ''
    function ya() {
      tmp="$(mktemp -t "yazi-cwd.XXXXX")"
      yazi --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';

  fishSetCwd = ''
    function ya
      set tmp (mktemp -t "yazi-cwd.XXXXX")
      yazi --cwd-file="$tmp"
      if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
      end
      rm -f -- "$tmp"
    end
  '';
in
{
  options.programs.yazi = {
    enable = lib.mkEnableOption (lib.mdDoc "yazi terminal file manager");

    enableBashIntegration = lib.mkEnableOption (lib.mdDoc "setting current working dir in bash on exit");

    enableFishIntegration = lib.mkEnableOption (lib.mdDoc "setting current working dir in fish on exit");

    enableZshIntegration = lib.mkEnableOption (lib.mdDoc "setting current working dir in zsh on exit");

    package = lib.mkPackageOptionMD pkgs "yazi" { };

    settings = lib.mkOption {
      type = with lib.types; submodule {
        options = lib.listToAttrs (map
          (name: lib.nameValuePair name (lib.mkOption {
            inherit (settingsFormat) type;
            default = { };
            description = lib.mdDoc ''
              Configuration included in `${name}.toml`.

              See https://github.com/sxyazi/yazi/blob/v${cfg.package.version}/config/docs/${name}.md for documentation.
            '';
          }))
          names);
      };
      default = { };
      description = lib.mdDoc ''
        Configuration included in `$YAZI_CONFIG_HOME`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      variables.YAZI_CONFIG_HOME = "/etc/yazi/";
      etc = lib.attrsets.mergeAttrsList (map
        (name: lib.optionalAttrs (cfg.settings.${name} != { }) {
          "yazi/${name}.toml".source = settingsFormat.generate "${name}.toml" cfg.settings.${name};
        })
        names);
    };

    programs = {
      bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration bashSetCwd;
      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration bashSetCwd;
      zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration bashSetCwd;
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ linsui ];
    # The version of the package is used in the doc.
    buildDocsInSandbox = false;
  };
}
