{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.doas;

  mkUsrString = user: toString user;

  mkGrpString = group: ":${toString group}";

  mkOpts =
    rule:
    lib.concatStringsSep " " [
      (lib.optionalString rule.noPass "nopass")
      (lib.optionalString rule.noLog "nolog")
      (lib.optionalString rule.persist "persist")
      (lib.optionalString rule.keepEnv "keepenv")
      "setenv { SSH_AUTH_SOCK TERMINFO TERMINFO_DIRS ${lib.concatStringsSep " " rule.setEnv} }"
    ];

  mkArgs =
    rule:
    if (rule.args == null) then
      ""
    else if (rule.args == [ ]) then
      "args"
    else
      "args ${lib.concatStringsSep " " rule.args}";

  mkRule =
    rule:
    let
      opts = mkOpts rule;

      as = lib.optionalString (rule.runAs != null) "as ${rule.runAs}";

      cmd = lib.optionalString (rule.cmd != null) "cmd ${rule.cmd}";

      args = mkArgs rule;
    in
    lib.optionals (cfg.extraRules != [ ]) [
      (lib.optionalString (rule.users != [ ]) (
        map (usr: "permit ${opts} ${mkUsrString usr} ${as} ${cmd} ${args}") rule.users
      ))
      (lib.optionalString (rule.groups != [ ]) (
        map (grp: "permit ${opts} ${mkGrpString grp} ${as} ${cmd} ${args}") rule.groups
      ))
    ];
in
{

  ###### interface

  options.security.doas = {

    enable = lib.mkOption {
      type = with lib.types; bool;
      default = false;
      description = ''
        Whether to enable the {command}`doas` command, which allows
        non-root users to execute commands as root.
      '';
    };

    package = lib.mkPackageOption pkgs "doas" { };

    wheelNeedsPassword = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must provide a password to
        run commands as super user via {command}`doas`.
      '';
    };

    extraRules = lib.mkOption {
      default = [ ];
      description = ''
        Define specific rules to be set in the
        {file}`/etc/doas.conf` file. More specific rules should
        come after more general ones in order to yield the expected behavior.
        You can use `mkBefore` and/or `mkAfter` to ensure
        this is the case when configuration options are merged. Be aware that
        this option cannot be used to override the behaviour allowing
        passwordless operation for root.
      '';
      example = lib.literalExpression ''
        [
          # Allow execution of any command by any user in group doas, requiring
          # a password and keeping any previously-defined environment variables.
          { groups = [ "doas" ]; noPass = false; keepEnv = true; }

          # Allow execution of "/home/root/secret.sh" by user `backup` OR user
          # `database` OR any member of the group with GID `1006`, without a
          # password.
          { users = [ "backup" "database" ]; groups = [ 1006 ];
            cmd = "/home/root/secret.sh"; noPass = true; }

          # Allow any member of group `bar` to run `/home/baz/cmd1.sh` as user
          # `foo` with argument `hello-doas`.
          { groups = [ "bar" ]; runAs = "foo";
            cmd = "/home/baz/cmd1.sh"; args = [ "hello-doas" ]; }

          # Allow any member of group `bar` to run `/home/baz/cmd2.sh` as user
          # `foo` with no arguments.
          { groups = [ "bar" ]; runAs = "foo";
            cmd = "/home/baz/cmd2.sh"; args = [ ]; }

          # Allow user `abusers` to execute "nano" and unset the value of
          # SSH_AUTH_SOCK, override the value of ALPHA to 1, and inherit the
          # value of BETA from the current environment.
          { users = [ "abusers" ]; cmd = "nano";
            setEnv = [ "-SSH_AUTH_SOCK" "ALPHA=1" "BETA" ]; }
        ]
      '';
      type =
        with lib.types;
        listOf (submodule {
          options = {

            noPass = lib.mkOption {
              type = with types; bool;
              default = false;
              description = ''
                If `true`, the user is not required to enter a
                password.
              '';
            };

            noLog = lib.mkOption {
              type = with types; bool;
              default = false;
              description = ''
                If `true`, successful executions will not be logged
                to
                {manpage}`syslogd(8)`.
              '';
            };

            persist = lib.mkOption {
              type = with types; bool;
              default = false;
              description = ''
                If `true`, do not ask for a password again for some
                time after the user successfully authenticates.
              '';
            };

            keepEnv = lib.mkOption {
              type = with types; bool;
              default = false;
              description = ''
                If `true`, environment variables other than those
                listed in
                {manpage}`doas(1)`
                are kept when creating the environment for the new process.
              '';
            };

            setEnv = lib.mkOption {
              type = with types; listOf str;
              default = [ ];
              description = ''
                Keep or set the specified variables. Variables may also be
                removed with a leading '-' or set using
                `variable=value`. If the first character of
                `value` is a '$', the value to be set is taken from
                the existing environment variable of the indicated name. This
                option is processed after the default environment has been
                created.

                NOTE: All rules have `setenv { SSH_AUTH_SOCK }` by
                default. To prevent `SSH_AUTH_SOCK` from being
                inherited, add `"-SSH_AUTH_SOCK"` anywhere in this
                list.
              '';
            };

            users = lib.mkOption {
              type = with types; listOf (either str int);
              default = [ ];
              description = "The usernames / UIDs this rule should apply for.";
            };

            groups = lib.mkOption {
              type = with types; listOf (either str int);
              default = [ ];
              description = "The groups / GIDs this rule should apply for.";
            };

            runAs = lib.mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                Which user or group the specified command is allowed to run as.
                When set to `null` (the default), all users are
                allowed.

                A user can be specified using just the username:
                `"foo"`. It is also possible to only allow running as
                a specific group with `":bar"`.
              '';
            };

            cmd = lib.mkOption {
              type = with types; nullOr str;
              default = null;
              description = ''
                The command the user is allowed to run. When set to
                `null` (the default), all commands are allowed.

                NOTE: It is best practice to specify absolute paths. If a
                relative path is specified, only a restricted PATH will be
                searched.
              '';
            };

            args = lib.mkOption {
              type = with types; nullOr (listOf str);
              default = null;
              description = ''
                Arguments that must be provided to the command. When set to
                `[]`, the command must be run without any arguments.
              '';
            };
          };
        });
    };

    extraConfig = lib.mkOption {
      type = with lib.types; lines;
      default = "";
      description = ''
        Extra configuration text appended to {file}`doas.conf`. Be aware that
        this option cannot be used to override the behaviour allowing
        passwordless operation for root.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    security.doas.extraRules = lib.mkOrder 600 [
      {
        groups = [ "wheel" ];
        noPass = !cfg.wheelNeedsPassword;
      }
    ];

    security.wrappers.doas = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe cfg.package;
    };

    environment.systemPackages = [
      cfg.package
    ];

    security.pam.services.doas = {
      allowNullPassword = true;
      sshAgentAuth = true;
    };

    environment.etc."doas.conf" = {
      source =
        pkgs.runCommand "doas-conf"
          {
            src = pkgs.writeText "doas-conf-in" ''
              # To modify this file, set the NixOS options
              # `security.doas.extraRules` or `security.doas.extraConfig`. To
              # completely replace the contents of this file, use
              # `environment.etc."doas.conf"`.

              # extraRules
              ${lib.concatStringsSep "\n" (lib.lists.flatten (map mkRule cfg.extraRules))}

              # extraConfig
              ${cfg.extraConfig}

              # "root" is allowed to do anything.
              permit nopass keepenv root
            '';
            preferLocalBuild = true;
          }
          # Make sure that the doas.conf file is syntactically valid.
          "${pkgs.buildPackages.doas}/bin/doas -C $src && cp $src $out";
      mode = "0440";
    };

  };

  meta.maintainers = with lib.maintainers; [ cole-h ];
}
