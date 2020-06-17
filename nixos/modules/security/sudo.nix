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
        ''
          Whether to enable the <command>sudo</command> command, which
          allows non-root users to execute commands as root.
        '';
    };

    security.sudo.wheelNeedsPassword = mkOption {
      type = types.bool;
      default = true;
      description =
        ''
          Whether users of the <code>wheel</code> group must
          provide a password to run commands as super user via <command>sudo</command>.
        '';
      };

    security.sudo.configFile = mkOption {
      type = types.lines;
      # Note: if syntax errors are detected in this file, the NixOS
      # configuration will fail to build.
      description =
        ''
          This string contains the contents of the
          <filename>sudoers</filename> file.
        '';
    };

    security.sudo.extraRules = mkOption {
      description = ''
        Define specific rules to be in the <filename>sudoers</filename> file.
        More specific rules should come after more general ones in order to
        yield the expected behavior. You can use mkBefore/mkAfter to ensure
        this is the case when configuration options are merged.
      '';
      default = [];
      example = literalExample ''
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
            description = ''
              The usernames / UIDs this rule should apply for.
            '';
            default = [];
          };

          groups = mkOption {
            type = with types; listOf (either str int);
            description = ''
              The groups / GIDs this rule should apply for.
            '';
            default = [];
          };

          host = mkOption {
            type = types.str;
            default = "ALL";
            description = ''
              For what host this rule should apply.
            '';
          };

          runAs = mkOption {
            type = with types; str;
            default = "ALL:ALL";
            description = ''
              Under which user/group the specified command is allowed to run.

              A user can be specified using just the username: <code>"foo"</code>.
              It is also possible to specify a user/group combination using <code>"foo:bar"</code>
              or to only allow running as a specific group with <code>":bar"</code>.
            '';
          };

          commands = mkOption {
            description = ''
              The commands for which the rule should apply.
            '';
            type = with types; listOf (either str (submodule {

              options = {
                command = mkOption {
                  type = with types; str;
                  description = ''
                    A command being either just a path to a binary to allow any arguments,
                    the full command with arguments pre-set or with <code>""</code> used as the argument,
                    not allowing arguments to the command at all.
                  '';
                };

                options = mkOption {
                  type = with types; listOf (enum [ "NOPASSWD" "PASSWD" "NOEXEC" "EXEC" "SETENV" "NOSETENV" "LOG_INPUT" "NOLOG_INPUT" "LOG_OUTPUT" "NOLOG_OUTPUT" ]);
                  description = ''
                    Options for running the command. Refer to the <a href="https://www.sudo.ws/man/1.7.10/sudoers.man.html">sudo manual</a>.
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
      description = ''
        Extra configuration text appended to <filename>sudoers</filename>.
      '';
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    security.sudo.extraRules = [
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
              rule: if (length rule.commands != 0) then [
                (map (user: "${toUserString user}	${rule.host}=(${rule.runAs})	${toCommandsString rule.commands}") rule.users)
                (map (group: "${toGroupString group}	${rule.host}=(${rule.runAs})	${toCommandsString rule.commands}") rule.groups)
              ] else []
            ) cfg.extraRules
          )
        )}

        ${cfg.extraConfig}
      '';

    security.wrappers = {
      sudo.source = "${pkgs.sudo.out}/bin/sudo";
      sudoedit.source = "${pkgs.sudo.out}/bin/sudoedit";
    };

    environment.systemPackages = [ sudo ];

    security.pam.services.sudo = { sshAgentAuth = true; };

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
