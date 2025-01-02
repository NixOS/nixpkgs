{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    maintainers
    mapAttrs'
    mkEnableOption
    mkOption
    nameValuePair
    optionalString
    types
    ;
  mkSystemdService =
    name: cfg:
    nameValuePair "gitwatch-${name}" (
      let
        getvar = flag: var: optionalString (cfg."${var}" != null) "${flag} ${cfg."${var}"}";
        branch = getvar "-b" "branch";
        remote = getvar "-r" "remote";
      in
      rec {
        inherit (cfg) enable;
        after = [ "network-online.target" ];
        wants = after;
        wantedBy = [ "multi-user.target" ];
        description = "gitwatch for ${name}";
        path = with pkgs; [
          gitwatch
          git
          openssh
        ];
        script = ''
          if [ -n "${cfg.remote}" ] && ! [ -d "${cfg.path}" ]; then
            git clone ${branch} "${cfg.remote}" "${cfg.path}"
          fi
          gitwatch ${remote} ${branch} ${cfg.path}
        '';
        serviceConfig.User = cfg.user;
      }
    );
in
{
  options.services.gitwatch = mkOption {
    description = ''
      A set of git repositories to watch for. See
      [gitwatch](https://github.com/gitwatch/gitwatch) for more.
    '';
    default = { };
    example = {
      my-repo = {
        enable = true;
        user = "user";
        path = "/home/user/watched-project";
        remote = "git@github.com:me/my-project.git";
      };
      disabled-repo = {
        enable = false;
        user = "user";
        path = "/home/user/disabled-project";
        remote = "git@github.com:me/my-old-project.git";
        branch = "autobranch";
      };
    };
    type =
      with types;
      attrsOf (submodule {
        options = {
          enable = mkEnableOption "watching for repo";
          path = mkOption {
            description = "The path to repo in local machine";
            type = str;
          };
          user = mkOption {
            description = "The name of services's user";
            type = str;
            default = "root";
          };
          remote = mkOption {
            description = "Optional url of remote repository";
            type = nullOr str;
            default = null;
          };
          branch = mkOption {
            description = "Optional branch in remote repository";
            type = nullOr str;
            default = null;
          };
        };
      });
  };
  config.systemd.services = mapAttrs' mkSystemdService config.services.gitwatch;
  meta.maintainers = with maintainers; [ shved ];
}
