{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.security.please;
  ini = pkgs.formats.ini { };
in
{
  options.security.please = {
    enable = mkEnableOption ''
      please, a Sudo clone which allows a users to execute a command or edit a
      file as another user
    '';

    package = mkPackageOption pkgs "please" { };

    wheelNeedsPassword = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must provide a password to run
        commands or edit files with {command}`please` and
        {command}`pleaseedit` respectively.
      '';
    };

    settings = mkOption {
      type = ini.type;
      default = { };
      example = {
        jim_run_any_as_root = {
          name = "jim";
          type = "run";
          target = "root";
          rule = ".*";
          require_pass = false;
        };
        jim_edit_etc_hosts_as_root = {
          name = "jim";
          type = "edit";
          target = "root";
          rule = "/etc/hosts";
          editmode = 644;
          require_pass = true;
        };
      };
      description = ''
        Please configuration. Refer to
        <https://github.com/edneville/please/blob/master/please.ini.md> for
        details.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers =
      let
        owner = "root";
        group = "root";
        setuid = true;
      in
      {
        please = {
          source = "${cfg.package}/bin/please";
          inherit owner group setuid;
        };
        pleaseedit = {
          source = "${cfg.package}/bin/pleaseedit";
          inherit owner group setuid;
        };
      };

    security.please.settings = rec {
      # The "wheel" group is allowed to do anything by default but this can be
      # overridden.
      wheel_run_as_any = {
        type = "run";
        group = true;
        name = "wheel";
        target = ".*";
        rule = ".*";
        require_pass = cfg.wheelNeedsPassword;
      };
      wheel_edit_as_any = wheel_run_as_any // {
        type = "edit";
      };
      wheel_list_as_any = wheel_run_as_any // {
        type = "list";
      };
    };

    environment = {
      systemPackages = [ cfg.package ];

      etc."please.ini".source = ini.generate "please.ini" (
        cfg.settings
        // (rec {
          # The "root" user is allowed to do anything by default and this cannot
          # be overridden.
          root_run_as_any = {
            type = "run";
            name = "root";
            target = ".*";
            rule = ".*";
            require_pass = false;
          };
          root_edit_as_any = root_run_as_any // {
            type = "edit";
          };
          root_list_as_any = root_run_as_any // {
            type = "list";
          };
        })
      );
    };

    security.pam.services.please = {
      sshAgentAuth = true;
      usshAuth = true;
    };

    meta.maintainers = with maintainers; [ azahi ];
  };
}
