{ config, lib, ... }:
{
  meta = {
    maintainers = [ lib.maintainers.sandarukasa ] ++ lib.teams.freedesktop.members;
  };

  options = {
    xdg.directories =
      let
        mkXdgHome =
          name: default:
          lib.mkOption {
            type = lib.types.str;
            default = "$HOME/${default}/";
            description = "Value of `$XDG_${name}_HOME` environment variable";
          };
      in
      {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to define environment variables for some directories from
            [XDG Base Directory specification](https://specifications.freedesktop.org/basedir-spec/latest/).
            Namely:
            - `$XDG_CACHE_HOME`
            - `$XDG_CONFIG_HOME`
            - `$XDG_DATA_HOME`
            - `$XDG_STATE_HOME`
          '';
        };
        cache-home = mkXdgHome "CACHE" ".cache";
        config-home = mkXdgHome "CONFIG" ".config";
        data-home = mkXdgHome "DATA" ".local/share";
        state-home = mkXdgHome "STATE" ".local/state";
      };
  };

  config = lib.mkIf config.xdg.directories.enable {
    environment.sessionVariables = {
      XDG_CACHE_HOME = lib.mkDefault config.xdg.directories.cache-home;
      XDG_CONFIG_HOME = lib.mkDefault config.xdg.directories.config-home;
      XDG_DATA_HOME = lib.mkDefault config.xdg.directories.data-home;
      XDG_STATE_HOME = lib.mkDefault config.xdg.directories.state-home;
    };
  };

}
