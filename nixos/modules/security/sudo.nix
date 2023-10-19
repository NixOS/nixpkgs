{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.sudo;

  inherit (pkgs) sudo;

  toUserString = user: if (isInt user) then "#${toString user}" else "${user}";
  toGroupString = group: if (isInt group) then "%#${toString group}" else "%${group}";

  toCommandOptionsString = options:
    "${concatStringsSep ":" options}${optionalString (length options != 0) ":"} ";

  toCommandsString = commands:
    concatStringsSep ", " (
      map (command:
        if (isString command) then
          command
        else
          "${toCommandOptionsString command.options}${command.command}"
      ) commands
    );

in

{

  ###### interface

  options = {

    security.sudo.enable = mkOption {
      type = types.bool;
      default = true;
      description =
        lib.mdDoc ''
          Whether to enable the {command}`sudo` command, which
          allows non-root users to execute commands as root.
        '';
    };

    security.sudo.package = mkOption {
      type = types.package;
      default = pkgs.sudo;
      defaultText = literalExpression "pkgs.sudo";
      description = lib.mdDoc ''
        Which package to use for `sudo`.
      '';
    };

    security.sudo.wheelNeedsPassword = mkOption {
      type = types.bool;
      default = true;
      description =
        lib.mdDoc ''
          Whether users of the `wheel` group must
          provide a password to run commands as super user via {command}`sudo`.
        '';
      };

    security.sudo.execWheelOnly = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Only allow members of the `wheel` group to execute sudo by
        setting the executable's permissions accordingly.
        This prevents users that are not members of `wheel` from
        exploiting vulnerabilities in sudo such as CVE-2021-3156.
      '';
    };

    security.sudo.configFile = mkOption {
      type = types.lines;
      # Note: if syntax errors are detected in this file, the NixOS
      # configuration will fail to build.
      description =
        lib.mdDoc ''
          This string contains the contents of the
          {file}`sudoers` file.
        '';
    };

    security.sudo.extraRules = mkOption {
      description = lib.mdDoc ''
        Define specific rules to be in the {file}`sudoers` file.
        More specific rules should come after more general ones in order to
        yield the expected behavior. You can use mkBefore/mkAfter to ensure
        this is the case when configuration options are merged.
      '';
      default = [];
      example = literalExpression ''
        [
          # Allow execution of any command by all users in group sudo,
          # requiring a password.
          { groups = [ "sudo" ]; commands = [ "ALL" ]; }

          # Allow execution of "/home/root/secret.sh" by user `backup`, `database`
          # and the group with GID `1006` without a password.
          { users = [ "backup" "database" ]; groups = [ 1006 ];
            commands = [ { command = "/home/root/secret.sh"; options = [ "SETENV" "NOPASSWD" ]; } ]; }

          # Allow all users of group `bar` to run two executables as user `foo`
          # with arguments being pre-set.
          { groups = [ "bar" ]; runAs = "foo";
            commands =
              [ "/home/baz/cmd1.sh hello-sudo"
                  { command = '''/home/baz/cmd2.sh ""'''; options = [ "SETENV" ]; } ]; }
        ]
      '';
      type = with types; listOf (submodule {
        options = {
          users = mkOption {
            type = with types; listOf (either str int);
            description = lib.mdDoc ''
              The usernames / UIDs this rule should apply for.
            '';
            default = [];
          };

          groups = mkOption {
            type = with types; listOf (either str int);
            description = lib.mdDoc ''
              The groups / GIDs this rule should apply for.
            '';
            default = [];
          };

          host = mkOption {
            type = types.str;
            default = "ALL";
            description = lib.mdDoc ''
              For what host this rule should apply.
            '';
          };

          runAs = mkOption {
            type = with types; str;
            default = "ALL:ALL";
            description = lib.mdDoc ''
              Under which user/group the specified command is allowed to run.

              A user can be specified using just the username: `"foo"`.
              It is also possible to specify a user/group combination using `"foo:bar"`
              or to only allow running as a specific group with `":bar"`.
            '';
          };

          commands = mkOption {
            description = lib.mdDoc ''
              The commands for which the rule should apply.
            '';
            type = with types; listOf (either str (submodule {

              options = {
                command = mkOption {
                  type = with types; str;
                  description = lib.mdDoc ''
                    A command being either just a path to a binary to allow any arguments,
                    the full command with arguments pre-set or with `""` used as the argument,
                    not allowing arguments to the command at all.
                  '';
                };

                options = mkOption {
                  type = with types; listOf (enum [ "NOPASSWD" "PASSWD" "NOEXEC" "EXEC" "SETENV" "NOSETENV" "LOG_INPUT" "NOLOG_INPUT" "LOG_OUTPUT" "NOLOG_OUTPUT" ]);
                  description = lib.mdDoc ''
                    Options for running the command. Refer to the [sudo manual](https://www.sudo.ws/man/1.7.10/sudoers.man.html).
                  '';
                  default = [];
                };
              };

            }));
          };
        };
      });
    };

    security.sudo.extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra configuration text appended to {file}`sudoers`.
      '';
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.package.pname != "sudo-rs";
        message = "The NixOS `sudo` module does not work with `sudo-rs` yet."; }
    ];

    # We `mkOrder 600` so that the default rule shows up first, but there is
    # still enough room for a user to `mkBefore` it.
    security.sudo.extraRules = mkOrder 600 [
      { groups = [ "wheel" ];
        commands = [ { command = "ALL"; options = (if cfg.wheelNeedsPassword then [ "SETENV" ] else [ "NOPASSWD" "SETENV" ]); } ];
      }
    ];

    security.sudo.configFile =
      ''
        # Don't edit this file. Set the NixOS options ‘security.sudo.configFile’
        # or ‘security.sudo.extraRules’ instead.

        # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
        Defaults env_keep+=SSH_AUTH_SOCK

        # "root" is allowed to do anything.
        root        ALL=(ALL:ALL) SETENV: ALL

        # extraRules
        ${concatStringsSep "\n" (
          lists.flatten (
            map (
              rule: optionals (length rule.commands != 0) [
                (map (user: "${toUserString user}	${rule.host}=(${rule.runAs})	${toCommandsString rule.commands}") rule.users)
                (map (group: "${toGroupString group}	${rule.host}=(${rule.runAs})	${toCommandsString rule.commands}") rule.groups)
              ]
            ) cfg.extraRules
          )
        )}

        ${cfg.extraConfig}
      '';

    security.wrappers = let
      owner = "root";
      group = if cfg.execWheelOnly then "wheel" else "root";
      setuid = true;
      permissions = if cfg.execWheelOnly then "u+rx,g+x" else "u+rx,g+x,o+x";
    in {
      sudo = {
        source = "${cfg.package.out}/bin/sudo";
        inherit owner group setuid permissions;
      };
      sudoedit = {
        source = "${cfg.package.out}/bin/sudoedit";
        inherit owner group setuid permissions;
      };
    };

    environment.systemPackages = [ sudo ];

    security.pam.services.sudo = { sshAgentAuth = true; usshAuth = true; };

    environment.etc.sudoers =
      { source =
          pkgs.runCommand "sudoers"
          {
            src = pkgs.writeText "sudoers-in" cfg.configFile;
            preferLocalBuild = true;
          }
          # Make sure that the sudoers file is syntactically valid.
          # (currently disabled - NIXOS-66)
          "${pkgs.buildPackages.sudo}/sbin/visudo -f $src -c && cp $src $out";
        mode = "0440";
      };

  };

}
