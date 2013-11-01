# Global configuration for the SSH client.

{ config, pkgs, ... }:

with pkgs.lib;

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
        default = true;
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
  };
}
