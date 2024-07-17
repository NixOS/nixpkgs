{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.security.sudo-rs;

  toUserString = user: if (isInt user) then "#${toString user}" else "${user}";
  toGroupString = group: if (isInt group) then "%#${toString group}" else "%${group}";

  toCommandOptionsString =
    options: "${concatStringsSep ":" options}${optionalString (length options != 0) ":"} ";

  toCommandsString =
    commands:
    concatStringsSep ", " (
      map (
        command:
        if (isString command) then
          command
        else
          "${toCommandOptionsString command.options}${command.command}"
      ) commands
    );

in

{

  ###### interface

  options.security.sudo-rs = {

    defaultOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Options used for the default rules, granting `root` and the
        `wheel` group permission to run any command as any user.
      '';
    };

    enable = mkEnableOption ''
      a memory-safe implementation of the {command}`sudo` command,
      which allows non-root users to execute commands as root
    '';

    package = mkPackageOption pkgs "sudo-rs" { };

    wheelNeedsPassword = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must
        provide a password to run commands as super user via {command}`sudo`.
      '';
    };

    execWheelOnly = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Only allow members of the `wheel` group to execute sudo by
        setting the executable's permissions accordingly.
        This prevents users that are not members of `wheel` from
        exploiting vulnerabilities in sudo such as CVE-2021-3156.
      '';
    };

    configFile = mkOption {
      type = types.lines;
      # Note: if syntax errors are detected in this file, the NixOS
      # configuration will fail to build.
      description = ''
        This string contains the contents of the
        {file}`sudoers` file.
      '';
    };

    extraRules = mkOption {
      description = ''
        Define specific rules to be in the {file}`sudoers` file.
        More specific rules should come after more general ones in order to
        yield the expected behavior. You can use mkBefore/mkAfter to ensure
        this is the case when configuration options are merged.
      '';
      default = [ ];
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
      type =
        with types;
        listOf (submodule {
          options = {
            users = mkOption {
              type = with types; listOf (either str int);
              description = ''
                The usernames / UIDs this rule should apply for.
              '';
              default = [ ];
            };

            groups = mkOption {
              type = with types; listOf (either str int);
              description = ''
                The groups / GIDs this rule should apply for.
              '';
              default = [ ];
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

                A user can be specified using just the username: `"foo"`.
                It is also possible to specify a user/group combination using `"foo:bar"`
                or to only allow running as a specific group with `":bar"`.
              '';
            };

            commands = mkOption {
              description = ''
                The commands for which the rule should apply.
              '';
              type =
                with types;
                listOf (
                  either str (submodule {

                    options = {
                      command = mkOption {
                        type = with types; str;
                        description = ''
                          A command being either just a path to a binary to allow any arguments,
                          the full command with arguments pre-set or with `""` used as the argument,
                          not allowing arguments to the command at all.
                        '';
                      };

                      options = mkOption {
                        type =
                          with types;
                          listOf (enum [
                            "NOPASSWD"
                            "PASSWD"
                            "NOEXEC"
                            "EXEC"
                            "SETENV"
                            "NOSETENV"
                            "LOG_INPUT"
                            "NOLOG_INPUT"
                            "LOG_OUTPUT"
                            "NOLOG_OUTPUT"
                          ]);
                        description = ''
                          Options for running the command. Refer to the [sudo manual](https://www.sudo.ws/man/1.7.10/sudoers.man.html).
                        '';
                        default = [ ];
                      };
                    };

                  })
                );
            };
          };
        });
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration text appended to {file}`sudoers`.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.security.sudo.enable;
        message = "`security.sudo` and `security.sudo-rs` cannot both be enabled";
      }
    ];
    security.sudo.enable = mkDefault false;

    security.sudo-rs.extraRules =
      let
        defaultRule =
          {
            users ? [ ],
            groups ? [ ],
            opts ? [ ],
          }:
          [
            {
              inherit users groups;
              commands = [
                {
                  command = "ALL";
                  options = opts ++ cfg.defaultOptions;
                }
              ];
            }
          ];
      in
      mkMerge [
        # This is ordered before users' `mkBefore` rules,
        # so as not to introduce unexpected changes.
        (mkOrder 400 (defaultRule {
          users = [ "root" ];
        }))

        # This is ordered to show before (most) other rules, but
        # late-enough for a user to `mkBefore` it.
        (mkOrder 600 (defaultRule {
          groups = [ "wheel" ];
          opts = (optional (!cfg.wheelNeedsPassword) "NOPASSWD");
        }))
      ];

    security.sudo-rs.configFile = concatStringsSep "\n" (
      filter (s: s != "") [
        ''
          # Don't edit this file. Set the NixOS options ‘security.sudo-rs.configFile’
          # or ‘security.sudo-rs.extraRules’ instead.
        ''
        (pipe cfg.extraRules [
          (filter (rule: length rule.commands != 0))
          (map (rule: [
            (map (
              user: "${toUserString user}     ${rule.host}=(${rule.runAs})    ${toCommandsString rule.commands}"
            ) rule.users)
            (map (
              group: "${toGroupString group}  ${rule.host}=(${rule.runAs})    ${toCommandsString rule.commands}"
            ) rule.groups)
          ]))
          flatten
          (concatStringsSep "\n")
        ])
        "\n"
        (optionalString (cfg.extraConfig != "") ''
          # extraConfig
          ${cfg.extraConfig}
        '')
      ]
    );

    security.wrappers =
      let
        owner = "root";
        group = if cfg.execWheelOnly then "wheel" else "root";
        setuid = true;
        permissions = if cfg.execWheelOnly then "u+rx,g+x" else "u+rx,g+x,o+x";
      in
      {
        sudo = {
          source = "${cfg.package.out}/bin/sudo";
          inherit
            owner
            group
            setuid
            permissions
            ;
        };
      };

    environment.systemPackages = [ cfg.package ];

    security.pam.services.sudo = {
      sshAgentAuth = true;
      usshAuth = true;
    };
    security.pam.services.sudo-i = {
      sshAgentAuth = true;
      usshAuth = true;
    };

    environment.etc.sudoers = {
      source = pkgs.runCommand "sudoers" {
        src = pkgs.writeText "sudoers-in" cfg.configFile;
        preferLocalBuild = true;
      } "${pkgs.buildPackages.sudo-rs}/bin/visudo -f $src -c && cp $src $out";
      mode = "0440";
    };

  };

  meta.maintainers = [ lib.maintainers.nicoo ];

}
