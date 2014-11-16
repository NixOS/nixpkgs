# Global configuration for the SSH client.

{ config, lib, pkgs, ... }:

with lib;

let cfg  = config.programs.ssh;
    cfgd = config.services.openssh;

in
{
  ###### interface

  options = {

    programs.ssh = {

      forwardX11 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to request X11 forwarding on outgoing connections by default.
          This is useful for running graphical programs on the remote machine and have them display to your local X11 server.
          Historically, this value has depended on the value used by the local sshd daemon, but there really isn't a relation between the two.
          Note: there are some security risks to forwarding an X11 connection.
          NixOS's X server is built with the SECURITY extension, which prevents some obvious attacks.
          To enable or disable forwarding on a per-connection basis, see the -X and -x options to ssh.
          The -Y option to ssh enables trusted forwarding, which bypasses the SECURITY extension.
        '';
      };

      setXAuthLocation = mkOption {
        type = types.bool;
        default = config.services.xserver.enable;
        description = ''
          Whether to set the path to <command>xauth</command> for X11-forwarded connections.
          This causes a dependency on X11 packages.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration text appended to <filename>ssh_config</filename>.
          See <citerefentry><refentrytitle>ssh_config</refentrytitle><manvolnum>5</manvolnum></citerefentry>
          for help.
        '';
      };

      startAgent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
        '';
      };

      agentTimeout = mkOption {
        type = types.nullOr types.string;
        default = "1h";
        description = ''
          How long to keep the private keys in memory. Use null to keep them forever.
        '';
      };

      package = mkOption {
        default = pkgs.openssh;
        description = ''
          The package used for the openssh client and daemon.
        '';
      };

    };

  };

  config = {

    assertions = singleton
      { assertion = cfg.forwardX11 -> cfg.setXAuthLocation;
        message = "cannot enable X11 forwarding without setting XAuth location";
      };

    environment.etc =
      [ { # SSH configuration.  Slight duplication of the sshd_config
          # generation in the sshd service.
          source = pkgs.writeText "ssh_config" ''
            AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
            ${optionalString cfg.setXAuthLocation ''
              XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
            ''}
            ForwardX11 ${if cfg.forwardX11 then "yes" else "no"}
            ${cfg.extraConfig}
          '';
          target = "ssh/ssh_config";
        }
      ];

    # FIXME: this should really be socket-activated for über-awesomeness.
    systemd.user.services.ssh-agent =
      { enable = cfg.startAgent;
        description = "SSH Agent";
        wantedBy = [ "default.target" ];
        serviceConfig =
          { ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
            ExecStart =
                "${cfg.package}/bin/ssh-agent " +
                optionalString (cfg.agentTimeout != null) ("-t ${cfg.agentTimeout} ") +
                "-a %t/ssh-agent";
            StandardOutput = "null";
            Type = "forking";
            Restart = "on-failure";
            SuccessExitStatus = "0 2";
          };
      };

    environment.extraInit = optionalString cfg.startAgent
      ''
        if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
        fi
      '';

  };
}
