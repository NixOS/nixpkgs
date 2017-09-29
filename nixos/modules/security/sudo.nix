{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.sudo;

  inherit (pkgs) sudo;

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
          Whether users of the <code>wheel</code> group can execute
          commands as super user without entering a password.
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

    security.sudo.configFile =
      ''
        # Don't edit this file. Set the NixOS options ‘security.sudo.configFile’
        # or ‘security.sudo.extraConfig’ instead.

        # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
        Defaults env_keep+=SSH_AUTH_SOCK

        # "root" is allowed to do anything.
        root        ALL=(ALL:ALL) SETENV: ALL

        # Users in the "wheel" group can do anything.
        %wheel      ALL=(ALL:ALL) ${if cfg.wheelNeedsPassword then "" else "NOPASSWD: ALL, "}SETENV: ALL
        ${cfg.extraConfig}
      '';

    security.wrappers = {
      sudo.source = "${pkgs.sudo.out}/bin/sudo";
      sudoedit.source = "${pkgs.sudo.out}/bin/sudoedit";
    };

    environment.systemPackages = [ sudo ];

    security.pam.services.sudo = { sshAgentAuth = true; };

    environment.etc = singleton
      { source =
          pkgs.runCommand "sudoers"
          { src = pkgs.writeText "sudoers-in" cfg.configFile; }
          # Make sure that the sudoers file is syntactically valid.
          # (currently disabled - NIXOS-66)
          "${pkgs.sudo}/sbin/visudo -f $src -c && cp $src $out";
        target = "sudoers";
        mode = "0440";
      };

  };

}
