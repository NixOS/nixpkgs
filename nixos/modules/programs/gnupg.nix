{ config, lib, pkgs, ... }:

let
  inherit (lib) mkRemovedOptionModule mkOption mkPackageOption types mkIf optionalString;

  cfg = config.programs.gnupg;

  agentSettingsFormat = pkgs.formats.keyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
  };
in
{
  imports = [
    (mkRemovedOptionModule [ "programs" "gnupg" "agent" "pinentryFlavor" ] "Use programs.gnupg.agent.pinentryPackage instead")
  ];

  options.programs.gnupg = {
    package = mkPackageOption pkgs "gnupg" { };

    agent.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables GnuPG agent with socket-activation for every user session.
      '';
    };

    agent.enableSSHSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable SSH agent support in GnuPG agent. Also sets SSH_AUTH_SOCK
        environment variable correctly. This will disable socket-activation
        and thus always start a GnuPG agent per user session.
      '';
    };

    agent.enableExtraSocket = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable extra socket for GnuPG agent.
      '';
    };

    agent.enableBrowserSocket = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable browser socket for GnuPG agent.
      '';
    };

    agent.pinentryPackage = mkOption {
      type = types.nullOr types.package;
      example = lib.literalMD "pkgs.pinentry-gnome3";
      default = pkgs.pinentry-curses;
      defaultText = lib.literalMD "matching the configured desktop environment or `pkgs.pinentry-curses`";
      description = ''
        Which pinentry package to use. The path to the mainProgram as defined in
        the package's meta attriutes will be set in /etc/gnupg/gpg-agent.conf.
        If not set by the user, it'll pick an appropriate flavor depending on the
        system configuration (qt flavor for lxqt and plasma5, gtk2 for xfce,
        gnome3 on all other systems with X enabled, curses otherwise).
      '';
    };

    agent.settings = mkOption {
      type = agentSettingsFormat.type;
      default = { };
      example = {
        default-cache-ttl = 600;
      };
      description = ''
        Configuration for /etc/gnupg/gpg-agent.conf.
        See {manpage}`gpg-agent(1)` for supported options.
      '';
    };

    dirmngr.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables GnuPG network certificate management daemon with socket-activation for every user session.
      '';
    };
  };

  config = mkIf cfg.agent.enable {
    programs.gnupg.agent.settings = mkIf (cfg.agent.pinentryPackage != null) {
      pinentry-program = lib.getExe cfg.agent.pinentryPackage;
    };

    environment.etc."gnupg/gpg-agent.conf".source =
      agentSettingsFormat.generate "gpg-agent.conf" cfg.agent.settings;

    # This overrides the systemd user unit shipped with the gnupg package
    systemd.user.services.gpg-agent = {
      unitConfig = {
        Description = "GnuPG cryptographic agent and passphrase cache";
        Documentation = "man:gpg-agent(1)";
        Requires = [ "sockets.target" ];
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/gpg-agent --supervised";
        ExecReload = "${cfg.package}/bin/gpgconf --reload gpg-agent";
      };
    };

    systemd.user.sockets.gpg-agent = {
      unitConfig = {
        Description = "GnuPG cryptographic agent and passphrase cache";
        Documentation = "man:gpg-agent(1)";
      };
      socketConfig = {
        ListenStream = "%t/gnupg/S.gpg-agent";
        FileDescriptorName = "std";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-ssh = mkIf cfg.agent.enableSSHSupport {
      unitConfig = {
        Description = "GnuPG cryptographic agent (ssh-agent emulation)";
        Documentation = "man:gpg-agent(1) man:ssh-add(1) man:ssh-agent(1) man:ssh(1)";
      };
      socketConfig = {
        ListenStream = "%t/gnupg/S.gpg-agent.ssh";
        FileDescriptorName = "ssh";
        Service = "gpg-agent.service";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-extra = mkIf cfg.agent.enableExtraSocket {
      unitConfig = {
        Description = "GnuPG cryptographic agent and passphrase cache (restricted)";
        Documentation = "man:gpg-agent(1)";
      };
      socketConfig = {
        ListenStream = "%t/gnupg/S.gpg-agent.extra";
        FileDescriptorName = "extra";
        Service = "gpg-agent.service";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.sockets.gpg-agent-browser = mkIf cfg.agent.enableBrowserSocket {
      unitConfig = {
        Description = "GnuPG cryptographic agent and passphrase cache (access for web browsers)";
        Documentation = "man:gpg-agent(1)";
      };
      socketConfig = {
        ListenStream = "%t/gnupg/S.gpg-agent.browser";
        FileDescriptorName = "browser";
        Service = "gpg-agent.service";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.user.services.dirmngr = mkIf cfg.dirmngr.enable {
      unitConfig = {
        Description = "GnuPG network certificate management daemon";
        Documentation = "man:dirmngr(8)";
        Requires = "dirmngr.socket";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dirmngr --supervised";
        ExecReload = "${cfg.package}/bin/gpgconf --reload dirmngr";
      };
    };

    systemd.user.sockets.dirmngr = mkIf cfg.dirmngr.enable {
      unitConfig = {
        Description = "GnuPG network certificate management daemon";
        Documentation = "man:dirmngr(8)";
      };
      socketConfig = {
        ListenStream = "%t/gnupg/S.dirmngr";
        SocketMode = "0600";
        DirectoryMode = "0700";
      };
      wantedBy = [ "sockets.target" ];
    };

    services.dbus.packages = mkIf (lib.elem "gnome3" (cfg.agent.pinentryPackage.flavors or [])) [ pkgs.gcr ];

    environment.systemPackages = [ cfg.package ];

    environment.interactiveShellInit = ''
      # Bind gpg-agent to this TTY if gpg commands are used.
      export GPG_TTY=$(tty)
    '';

    programs.ssh.extraConfig = optionalString cfg.agent.enableSSHSupport ''
      # The SSH agent protocol doesn't have support for changing TTYs; however we
      # can simulate this with the `exec` feature of openssh (see ssh_config(5))
      # that hooks a command to the shell currently running the ssh program.
      Match host * exec "${pkgs.runtimeShell} -c '${cfg.package}/bin/gpg-connect-agent --quiet updatestartuptty /bye >/dev/null 2>&1'"
    '';

    environment.extraInit = mkIf cfg.agent.enableSSHSupport ''
      if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$(${cfg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
      fi
    '';

    assertions = [
      {
        assertion = cfg.agent.enableSSHSupport -> !config.programs.ssh.startAgent;
        message = "You can't use ssh-agent and GnuPG agent with SSH support enabled at the same time!";
      }
    ];
  };
}
