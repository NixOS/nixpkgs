{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix.sshServe;
  template =
    input: command: "    ${lib.escapeShellArg input})\n      ${lib.escapeShellArgs command}\n      ;;";
  buildCommand =
    commands:
    pkgs.writeShellApplication {
      name = "nix-serve-forcecommand";
      text = ''
        runCommand() {
          case "$1" in
        ${builtins.concatStringsSep "\n" (
          builtins.map ({ input, command }: template input command) commands
        )}
            # some implementations use "exec", emulate this
            "exec "*)
              runCommand "''${1##"exec "}"
              exit
              ;;
            # other commands are prohibited
            *)
              printf "not running unknown command '%s'\\n" "$1" >&2
              exit 1
          esac
        }

        # implementations may pass a command directly, however some implementations pass "bash" as the command to run interactively
        if test -n "''${SSH_ORIGINAL_COMMAND:+x}" && test "$SSH_ORIGINAL_COMMAND" != bash; then
          runCommand "$SSH_ORIGINAL_COMMAND"
        else
          while read -r line; do
            runCommand "$line"
          done
        fi
      '';
      runtimeInputs = [ config.nix.package ];
    };
  command = buildCommand cfg.allowed-commands;
in
{
  options = {

    nix.sshServe = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable serving the Nix store as a remote store via SSH.";
      };

      write = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable writing to the Nix store as a remote store via SSH. Note: by default, the sshServe user is named nix-ssh and is not a trusted-user. nix-ssh should be added to the {option}`nix.sshServe.trusted` option in most use cases, such as allowing remote building of derivations to anonymous people based on ssh key";
      };

      trusted = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to add nix-ssh to the nix.settings.trusted-users";
      };

      keys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "ssh-dss AAAAB3NzaC1k... alice@example.org" ];
        description = "A list of SSH public keys allowed to access the binary cache via SSH.";
      };

      protocol = lib.mkOption {
        type = lib.types.enum [
          "ssh"
          "ssh-ng"
        ];
        default = "ssh";
        description = "The specific Nix-over-SSH protocol to use.";
      };

      allowed-commands = lib.mkOption {
        description = ''
          List of commands to handle in the SSH *ForceCommand*.

          Since some implementations use multiple commands (such as `echo started` as a ready-check)
          it is important to be able to handle multiple commands.
          Additionally those commands may be presented multiple ways (as arguments, on stdin, etc.).
          This is a complete list of input/command pairs where the verbatim input triggers the
          corresponding command.
        '';
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              input = lib.mkOption {
                type = lib.types.str;
                description = "Raw input string as passed to the *ForceCommand*.";
                example = "nix-store --serve";
              };
              command = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = ''
                  Command as an array of strings to exec.

                  If you need to shell out (e.g. to run multiple commands), use `[ "sh" "-c" "my_code" ]` or similar.
                '';
                example = [
                  "nix-store"
                  "--serve"
                ];
              };
            };
          }
        );
        defaultText = ''
          Depending on the chosen protocol and whether write support is enabled, appropriate commands are enabled:

          - `nix-store --serve`
          - `nix-store --serve --write`
          - `nix-daemon --stdio`
        '';
        default = (
          [
            {
              input = "echo started";
              command = [
                "echo"
                "started"
              ];
            }
          ]
          ++ lib.optional (cfg.protocol == "ssh") {
            input = "nix-store --serve";
            command = [
              "nix-store"
              "--serve"
            ];
          }
          ++ lib.optional (cfg.protocol == "ssh" && cfg.write) {
            input = "nix-store --serve --write";
            command = [
              "nix-store"
              "--serve"
              "--write"
            ];
          }
          ++ lib.optional (cfg.protocol == "ssh-ng") {
            input = "nix-daemon --stdio";
            command = [
              "nix-daemon"
              "--stdio"
            ];
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.nix-ssh = {
      description = "Nix SSH store user";
      isSystemUser = true;
      group = "nix-ssh";
      shell = pkgs.bashInteractive;
    };
    users.groups.nix-ssh = { };

    nix.settings.trusted-users = lib.mkIf cfg.trusted [ "nix-ssh" ];

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User nix-ssh
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
        ForceCommand ${command.out}/bin/nix-serve-forcecommand
      Match All
    '';

    users.users.nix-ssh.openssh.authorizedKeys.keys = cfg.keys;

  };
}
