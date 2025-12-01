{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.security.sudo;

  toUserString = user: if (lib.isInt user) then "#${toString user}" else "${user}";
  toGroupString = group: if (lib.isInt group) then "%#${toString group}" else "%${group}";

  toCommandOptionsString =
    options: "${lib.concatStringsSep ":" options}${lib.optionalString (lib.length options != 0) ":"} ";

  toCommandsString =
    commands:
    lib.concatStringsSep ", " (
      map (
        command:
        if (lib.isString command) then
          command
        else
          "${toCommandOptionsString command.options}${command.command}"
      ) commands
    );

in

{

  ###### interface

  options.security.sudo = {

    defaultOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "SETENV" ];
      description = ''
        Options used for the default rules, granting `root` and the
        `wheel` group permission to run any command as any user.
      '';
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable the {command}`sudo` command, which
        allows non-root users to execute commands as root.
      '';
    };

    package = lib.mkPackageOption pkgs "sudo" { };

    wheelNeedsPassword = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must
        provide a password to run commands as super user via {command}`sudo`.
      '';
    };

    execWheelOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Only allow members of the `wheel` group to execute sudo by
        setting the executable's permissions accordingly.
        This prevents users that are not members of `wheel` from
        exploiting vulnerabilities in sudo such as CVE-2021-3156.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.lines;
      # Note: if syntax errors are detected in this file, the NixOS
      # configuration will fail to build.
      description = ''
        This string contains the contents of the
        {file}`sudoers` file.
      '';
    };

    extraRules = lib.mkOption {
      description = ''
        Define specific rules to be in the {file}`sudoers` file.
        More specific rules should come after more general ones in order to
        yield the expected behavior. You can use mkBefore/mkAfter to ensure
        this is the case when configuration options are merged.
      '';
      default = [ ];
      example = lib.literalExpression ''
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
        with lib.types;
        listOf (submodule {
          options = {
            users = lib.mkOption {
              type = with types; listOf (either str int);
              description = ''
                The usernames / UIDs this rule should apply for.
              '';
              default = [ ];
            };

            groups = lib.mkOption {
              type = with types; listOf (either str int);
              description = ''
                The groups / GIDs this rule should apply for.
              '';
              default = [ ];
            };

            host = lib.mkOption {
              type = types.str;
              default = "ALL";
              description = ''
                For what host this rule should apply.
              '';
            };

            runAs = lib.mkOption {
              type = with types; str;
              default = "ALL:ALL";
              description = ''
                Under which user/group the specified command is allowed to run.

                A user can be specified using just the username: `"foo"`.
                It is also possible to specify a user/group combination using `"foo:bar"`
                or to only allow running as a specific group with `":bar"`.
              '';
            };

            commands = lib.mkOption {
              description = ''
                The commands for which the rule should apply.
              '';
              type =
                with types;
                listOf (
                  either str (submodule {

                    options = {
                      command = lib.mkOption {
                        type = with types; str;
                        description = ''
                          A command being either just a path to a binary to allow any arguments,
                          the full command with arguments pre-set or with `""` used as the argument,
                          not allowing arguments to the command at all.
                        '';
                      };

                      options = lib.mkOption {
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
                            "MAIL"
                            "NOMAIL"
                            "FOLLOW"
                            "NOFLLOW"
                            "INTERCEPT"
                            "NOINTERCEPT"
                          ]);
                        description = ''
                          Options for running the command. Refer to the [sudo manual](https://www.sudo.ws/docs/man/1.9.17/sudoers.man/#Tag_Spec).
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

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration text appended to {file}`sudoers`.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package.pname != "sudo-rs";
        message = ''
          NixOS' `sudo` module does not support `sudo-rs`; see `security.sudo-rs` instead.
        '';
      }
    ];

    security.sudo.extraRules =
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
      lib.mkMerge [
        # This is ordered before users' `mkBefore` rules,
        # so as not to introduce unexpected changes.
        (lib.mkOrder 400 (defaultRule {
          users = [ "root" ];
        }))

        # This is ordered to show before (most) other rules, but
        # late-enough for a user to `mkBefore` it.
        (lib.mkOrder 600 (defaultRule {
          groups = [ "wheel" ];
          opts = (lib.optional (!cfg.wheelNeedsPassword) "NOPASSWD");
        }))
      ];

    security.sudo.configFile = lib.concatStringsSep "\n" (
      lib.filter (s: s != "") [
        ''
          # Don't edit this file. Set the NixOS options ‘security.sudo.configFile’
          # or ‘security.sudo.extraRules’ instead.
        ''
        (lib.pipe cfg.extraRules [
          (lib.filter (rule: lib.length rule.commands != 0))
          (map (rule: [
            (map (
              user: "${toUserString user}     ${rule.host}=(${rule.runAs})    ${toCommandsString rule.commands}"
            ) rule.users)
            (map (
              group: "${toGroupString group}  ${rule.host}=(${rule.runAs})    ${toCommandsString rule.commands}"
            ) rule.groups)
          ]))
          lib.flatten
          (lib.concatStringsSep "\n")
        ])
        "\n"
        (lib.optionalString (cfg.extraConfig != "") ''
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
        sudoedit = {
          source = "${cfg.package.out}/bin/sudoedit";
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

    environment.etc.sudoers = {
      source =
        pkgs.runCommand "sudoers"
          {
            src = pkgs.writeText "sudoers-in" cfg.configFile;

          }
          # Make sure that the sudoers file is syntactically valid.
          # (currently disabled - NIXOS-66)
          "${pkgs.buildPackages.sudo}/sbin/visudo -f $src -c && cp $src $out";
      mode = "0440";
    };

  };

}
