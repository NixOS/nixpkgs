# Global configuration for the SSH client.

{config, pkgs, ...}:

with pkgs.lib;

let cfg  = config.programs.ssh;
    cfgd = config.services.openssh;

in
{
  ###### interface

  options = {

    programs.ssh = {

      forwardX11 = mkOption {
        default = cfgd.forwardX11;
        description = ''
          Whether to request X11 forwarding on outgoing connections by default.
          This is useful for running graphical programs on the remote machine and have them display to your local X11 server.
          Historically, this value has depended on the value used by the local sshd daemon, but there really isn't a relation between the two.
        '';
      };

      setXAuthLocation = mkOption {
        default = true;
        description = ''
          Whether to set the path to xauth for X11-forwarded connections.
          Pulls in X11 dependency.
        '';
      };
    };
  };

  assertions = [{ assertion = if cfg.forwardX11 then cfg.setXAuthLocation else true; 
                  message = "cannot enable X11 forwarding without setting xauth location";}];

  config = {
    environment.etc =
      [ { # SSH configuration.  Slight duplication of the sshd_config
          # generation in the sshd service.
          source = pkgs.writeText "ssh_config" ''
            ${optionalString cfg.setXAuthLocation ''
              XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
            ''}
            ${if cfg.forwardX11 then ''
              ForwardX11 yes
            '' else ''
              ForwardX11 no
            ''}
          '';
          target = "ssh/ssh_config";
        }
      ];
  };
}
