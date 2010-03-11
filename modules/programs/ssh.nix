# Global configuration for the SSH client.

{config, pkgs, ...}:

{
  environment.etc =
    [ { # SSH configuration.  Slight duplication of the sshd_config
        # generation in the sshd service.
        source = pkgs.writeText "ssh_config" ''
          ${if config.services.openssh.forwardX11 then ''
            ForwardX11 yes
            XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
          '' else ''
            ForwardX11 no
          ''}
        '';
        target = "ssh/ssh_config";
      }
    ];
}
