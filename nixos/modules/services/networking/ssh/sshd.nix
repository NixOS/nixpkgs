{ config, lib, pkgs, ... }:

with lib;

let

  # The splicing information needed for nativeBuildInputs isn't available
  # on the derivations likely to be used as `cfgc.package`.
  # This middle-ground solution ensures *an* sshd can do their basic validation
  # on the configuration.
  validationPackage = if pkgs.stdenv.buildPlatform == pkgs.stdenv.hostPlatform
    then cfgc.package
    else pkgs.buildPackages.openssh;

  # reports boolean as yes / no
  mkValueStringSshd = with lib; v:
        if isInt           v then toString v
        else if isString   v then v
        else if true  ==   v then "yes"
        else if false ==   v then "no"
        else if isList     v then concatStringsSep "," v
        else throw "unsupported type ${builtins.typeOf v}: ${(lib.generators.toPretty {}) v}";

  # dont use the "=" operator
  settingsFormat = (pkgs.formats.keyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = mkValueStringSshd;
    } " ";});

  configFile = settingsFormat.generate "config" cfg.settings;
  sshconf = pkgs.runCommand "sshd.conf-validated" { nativeBuildInputs = [ validationPackage ]; } ''
    cat ${configFile} - >$out <<EOL
    ${cfg.extraConfig}
    EOL

    ssh-keygen -q -f mock-hostkey -N ""
    sshd -t -f $out -h mock-hostkey
  '';

  cfg  = config.services.openssh;
  cfgc = config.programs.ssh;


  nssModulesPath = config.system.nssModules.path;

  userOptions = {

    options.openssh.authorizedKeys = {
      keys = mkOption {
        type = types.listOf types.singleLineStr;
        default = [];
        description = lib.mdDoc ''
          A list of verbatim OpenSSH public keys that should be added to the
          user's authorized keys. The keys are added to a file that the SSH
          daemon reads in addition to the the user's authorized_keys file.
          You can combine the `keys` and
          `keyFiles` options.
          Warning: If you are using `NixOps` then don't use this
          option since it will replace the key required for deployment via ssh.
        '';
        example = [
          "ssh-rsa AAAAB3NzaC1yc2etc/etc/etcjwrsh8e596z6J0l7 example@host"
          "ssh-ed25519 AAAAC3NzaCetcetera/etceteraJZMfk3QPfQ foo@bar"
        ];
      };

      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          A list of files each containing one OpenSSH public key that should be
          added to the user's authorized keys. The contents of the files are
          read at build time and added to a file that the SSH daemon reads in
          addition to the the user's authorized_keys file. You can combine the
          `keyFiles` and `keys` options.
        '';
      };
    };

  };

  authKeysFiles = let
    mkAuthKeyFile = u: nameValuePair "ssh/authorized_keys.d/${u.name}" {
      mode = "0444";
      source = pkgs.writeText "${u.name}-authorized_keys" ''
        ${concatStringsSep "\n" u.openssh.authorizedKeys.keys}
        ${concatMapStrings (f: readFile f + "\n") u.openssh.authorizedKeys.keyFiles}
      '';
    };
    usersWithKeys = attrValues (flip filterAttrs config.users.users (n: u:
      length u.openssh.authorizedKeys.keys != 0 || length u.openssh.authorizedKeys.keyFiles != 0
    ));
  in listToAttrs (map mkAuthKeyFile usersWithKeys);

in

{
  imports = [
    (mkAliasOptionModuleMD [ "services" "sshd" "enable" ] [ "services" "openssh" "enable" ])
    (mkAliasOptionModuleMD [ "services" "openssh" "knownHosts" ] [ "programs" "ssh" "knownHosts" ])
    (mkRenamedOptionModule [ "services" "openssh" "challengeResponseAuthentication" ] [ "services" "openssh" "kbdInteractiveAuthentication" ])

    (mkRenamedOptionModule [ "services" "openssh" "kbdInteractiveAuthentication" ] [  "services" "openssh" "settings" "KbdInteractiveAuthentication" ])
    (mkRenamedOptionModule [ "services" "openssh" "passwordAuthentication" ] [  "services" "openssh" "settings" "PasswordAuthentication" ])
    (mkRenamedOptionModule [ "services" "openssh" "useDns" ] [  "services" "openssh" "settings" "UseDns" ])
    (mkRenamedOptionModule [ "services" "openssh" "permitRootLogin" ] [  "services" "openssh" "settings" "PermitRootLogin" ])
    (mkRenamedOptionModule [ "services" "openssh" "logLevel" ] [  "services" "openssh" "settings" "LogLevel" ])
    (mkRenamedOptionModule [ "services" "openssh" "macs" ] [  "services" "openssh" "settings" "Macs" ])
    (mkRenamedOptionModule [ "services" "openssh" "ciphers" ] [  "services" "openssh" "settings" "Ciphers" ])
    (mkRenamedOptionModule [ "services" "openssh" "kexAlgorithms" ] [  "services" "openssh" "settings" "KexAlgorithms" ])
    (mkRenamedOptionModule [ "services" "openssh" "gatewayPorts" ] [  "services" "openssh" "settings" "GatewayPorts" ])
    (mkRenamedOptionModule [ "services" "openssh" "forwardX11" ] [  "services" "openssh" "settings" "X11Forwarding" ])
  ];

  ###### interface

  options = {

    services.openssh = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
        '';
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If set, {command}`sshd` is socket-activated; that
          is, instead of having it permanently running as a daemon,
          systemd will start an instance for each incoming connection.
        '';
      };

      allowSFTP = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the SFTP subsystem in the SSH daemon.  This
          enables the use of commands such as {command}`sftp` and
          {command}`sshfs`.
        '';
      };

      sftpServerExecutable = mkOption {
        type = types.str;
        example = "internal-sftp";
        description = lib.mdDoc ''
          The sftp server executable.  Can be a path or "internal-sftp" to use
          the sftp server built into the sshd binary.
        '';
      };

      sftpFlags = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "-f AUTHPRIV" "-l INFO" ];
        description = lib.mdDoc ''
          Commandline flags to add to sftp-server.
        '';
      };

      ports = mkOption {
        type = types.listOf types.port;
        default = [22];
        description = lib.mdDoc ''
          Specifies on which ports the SSH daemon listens.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to automatically open the specified ports in the firewall.
        '';
      };

      listenAddresses = mkOption {
        type = with types; listOf (submodule {
          options = {
            addr = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = lib.mdDoc ''
                Host, IPv4 or IPv6 address to listen to.
              '';
            };
            port = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = lib.mdDoc ''
                Port to listen to.
              '';
            };
          };
        });
        default = [];
        example = [ { addr = "192.168.3.1"; port = 22; } { addr = "0.0.0.0"; port = 64022; } ];
        description = lib.mdDoc ''
          List of addresses and ports to listen on (ListenAddress directive
          in config). If port is not specified for address sshd will listen
          on all ports specified by `ports` option.
          NOTE: this will override default listening on all local addresses and port 22.
          NOTE: setting this option won't automatically enable given ports
          in firewall configuration.
        '';
      };

      hostKeys = mkOption {
        type = types.listOf types.attrs;
        default =
          [ { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
            { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
          ];
        example =
          [ { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; rounds = 100; openSSHFormat = true; }
            { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; rounds = 100; comment = "key comment"; }
          ];
        description = lib.mdDoc ''
          NixOS can automatically generate SSH host keys.  This option
          specifies the path, type and size of each key.  See
          {manpage}`ssh-keygen(1)` for supported types
          and sizes.
        '';
      };

      banner = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = lib.mdDoc ''
          Message to display to the remote user before authentication is allowed.
        '';
      };

      authorizedKeysFiles = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Specify the rules for which files to read on the host.

          This is an advanced option. If you're looking to configure user
          keys, you can generally use [](#opt-users.users._name_.openssh.authorizedKeys.keys)
          or [](#opt-users.users._name_.openssh.authorizedKeys.keyFiles).

          These are paths relative to the host root file system or home
          directories and they are subject to certain token expansion rules.
          See AuthorizedKeysFile in man sshd_config for details.
        '';
      };

      authorizedKeysCommand = mkOption {
        type = types.str;
        default = "none";
        description = lib.mdDoc ''
          Specifies a program to be used to look up the user's public
          keys. The program must be owned by root, not writable by group
          or others and specified by an absolute path.
        '';
      };

      authorizedKeysCommandUser = mkOption {
        type = types.str;
        default = "nobody";
        description = lib.mdDoc ''
          Specifies the user under whose account the AuthorizedKeysCommand
          is run. It is recommended to use a dedicated user that has no
          other role on the host than running authorized keys commands.
        '';
      };



      settings = mkOption {
        description = lib.mdDoc "Configuration for `sshd_config(5)`.";
        default = { };
        example = literalExpression ''{
          UseDns = true;
          PasswordAuthentication = false;
        }'';
        type = types.submodule ({name, ...}: {
          freeformType = settingsFormat.type;
          options = {
            LogLevel = mkOption {
              type = types.enum [ "QUIET" "FATAL" "ERROR" "INFO" "VERBOSE" "DEBUG" "DEBUG1" "DEBUG2" "DEBUG3" ];
              default = "INFO"; # upstream default
              description = lib.mdDoc ''
                Gives the verbosity level that is used when logging messages from sshd(8). Logging with a DEBUG level
                violates the privacy of users and is not recommended.
              '';
            };
            UseDns = mkOption {
              type = types.bool;
              # apply if cfg.useDns then "yes" else "no"
              default = false;
              description = lib.mdDoc ''
                Specifies whether sshd(8) should look up the remote host name, and to check that the resolved host name for
                the remote IP address maps back to the very same IP address.
                If this option is set to no (the default) then only addresses and not host names may be used in
                ~/.ssh/authorized_keys from and sshd_config Match Host directives.
              '';
            };
            X11Forwarding = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Whether to allow X11 connections to be forwarded.
              '';
            };
            PasswordAuthentication = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Specifies whether password authentication is allowed.
              '';
            };
            PermitRootLogin = mkOption {
              default = "prohibit-password";
              type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
              description = lib.mdDoc ''
                Whether the root user can login using ssh.
              '';
            };
            KbdInteractiveAuthentication = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Specifies whether keyboard-interactive authentication is allowed.
              '';
            };
            GatewayPorts = mkOption {
              type = types.str;
              default = "no";
              description = lib.mdDoc ''
                Specifies whether remote hosts are allowed to connect to
                ports forwarded for the client.  See
                {manpage}`sshd_config(5)`.
              '';
            };
            KexAlgorithms = mkOption {
              type = types.listOf types.str;
              default = [
                "sntrup761x25519-sha512@openssh.com"
                "curve25519-sha256"
                "curve25519-sha256@libssh.org"
                "diffie-hellman-group-exchange-sha256"
              ];
              description = lib.mdDoc ''
                Allowed key exchange algorithms

                Uses the lower bound recommended in both
                <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                and
                <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
              '';
            };
            Macs = mkOption {
              type = types.listOf types.str;
              default = [
                "hmac-sha2-512-etm@openssh.com"
                "hmac-sha2-256-etm@openssh.com"
                "umac-128-etm@openssh.com"
              ];
              description = lib.mdDoc ''
                Allowed MACs

                Defaults to recommended settings from both
                <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                and
                <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
              '';
            };
            StrictModes = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether sshd should check file modes and ownership of directories
              '';
            };
            Ciphers = mkOption {
              type = types.listOf types.str;
              default = [
                "chacha20-poly1305@openssh.com"
                "aes256-gcm@openssh.com"
                "aes128-gcm@openssh.com"
                "aes256-ctr"
                "aes192-ctr"
                "aes128-ctr"
              ];
              description = lib.mdDoc ''
                Allowed ciphers

                Defaults to recommended settings from both
                <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                and
                <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
              '';
            };
          };
        });
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Verbatim contents of {file}`sshd_config`.";
      };

      moduliFile = mkOption {
        example = "/etc/my-local-ssh-moduli;";
        type = types.path;
        description = lib.mdDoc ''
          Path to `moduli` file to install in
          `/etc/ssh/moduli`. If this option is unset, then
          the `moduli` file shipped with OpenSSH will be used.
        '';
      };

    };

    users.users = mkOption {
      type = with types; attrsOf (submodule userOptions);
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.sshd =
      {
        isSystemUser = true;
        group = "sshd";
        description = "SSH privilege separation user";
      };
    users.groups.sshd = {};

    services.openssh.moduliFile = mkDefault "${cfgc.package}/etc/ssh/moduli";
    services.openssh.sftpServerExecutable = mkDefault "${cfgc.package}/libexec/sftp-server";

    environment.etc = authKeysFiles //
      { "ssh/moduli".source = cfg.moduliFile;
        "ssh/sshd_config".source = sshconf;
      };

    systemd =
      let
        service =
          { description = "SSH Daemon";
            wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";
            after = [ "network.target" ];
            stopIfChanged = false;
            path = [ cfgc.package pkgs.gawk ];
            environment.LD_LIBRARY_PATH = nssModulesPath;

            restartTriggers = optionals (!cfg.startWhenNeeded) [
              config.environment.etc."ssh/sshd_config".source
            ];

            preStart =
              ''
                # Make sure we don't write to stdout, since in case of
                # socket activation, it goes to the remote side (#19589).
                exec >&2

                ${flip concatMapStrings cfg.hostKeys (k: ''
                  if ! [ -s "${k.path}" ]; then
                      if ! [ -h "${k.path}" ]; then
                          rm -f "${k.path}"
                      fi
                      mkdir -m 0755 -p "$(dirname '${k.path}')"
                      ssh-keygen \
                        -t "${k.type}" \
                        ${optionalString (k ? bits) "-b ${toString k.bits}"} \
                        ${optionalString (k ? rounds) "-a ${toString k.rounds}"} \
                        ${optionalString (k ? comment) "-C '${k.comment}'"} \
                        ${optionalString (k ? openSSHFormat && k.openSSHFormat) "-o"} \
                        -f "${k.path}" \
                        -N ""
                  fi
                '')}
              '';

            serviceConfig =
              { ExecStart =
                  (optionalString cfg.startWhenNeeded "-") +
                  "${cfgc.package}/bin/sshd " + (optionalString cfg.startWhenNeeded "-i ") +
                  "-D " +  # don't detach into a daemon process
                  "-f /etc/ssh/sshd_config";
                KillMode = "process";
              } // (if cfg.startWhenNeeded then {
                StandardInput = "socket";
                StandardError = "journal";
              } else {
                Restart = "always";
                Type = "simple";
              });

          };
      in

      if cfg.startWhenNeeded then {

        sockets.sshd =
          { description = "SSH Socket";
            wantedBy = [ "sockets.target" ];
            socketConfig.ListenStream = if cfg.listenAddresses != [] then
              map (l: "${l.addr}:${toString (if l.port != null then l.port else 22)}") cfg.listenAddresses
            else
              cfg.ports;
            socketConfig.Accept = true;
            # Prevent brute-force attacks from shutting down socket
            socketConfig.TriggerLimitIntervalSec = 0;
          };

        services."sshd@" = service;

      } else {

        services.sshd = service;

      };

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall cfg.ports;

    security.pam.services.sshd =
      { startSession = true;
        showMotd = true;
        unixAuth = cfg.settings.PasswordAuthentication;
      };

    # These values are merged with the ones defined externally, see:
    # https://github.com/NixOS/nixpkgs/pull/10155
    # https://github.com/NixOS/nixpkgs/pull/41745
    services.openssh.authorizedKeysFiles =
      [ "%h/.ssh/authorized_keys" "/etc/ssh/authorized_keys.d/%u" ];

    services.openssh.extraConfig = mkOrder 0
      ''
        UsePAM yes

        Banner ${if cfg.banner == null then "none" else pkgs.writeText "ssh_banner" cfg.banner}

        AddressFamily ${if config.networking.enableIPv6 then "any" else "inet"}
        ${concatMapStrings (port: ''
          Port ${toString port}
        '') cfg.ports}

        ${concatMapStrings ({ port, addr, ... }: ''
          ListenAddress ${addr}${optionalString (port != null) (":" + toString port)}
        '') cfg.listenAddresses}

        ${optionalString cfgc.setXAuthLocation ''
            XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}
        ${optionalString cfg.allowSFTP ''
          Subsystem sftp ${cfg.sftpServerExecutable} ${concatStringsSep " " cfg.sftpFlags}
        ''}
        PrintMotd no # handled by pam_motd
        AuthorizedKeysFile ${toString cfg.authorizedKeysFiles}
        ${optionalString (cfg.authorizedKeysCommand != "none") ''
          AuthorizedKeysCommand ${cfg.authorizedKeysCommand}
          AuthorizedKeysCommandUser ${cfg.authorizedKeysCommandUser}
        ''}

        ${flip concatMapStrings cfg.hostKeys (k: ''
          HostKey ${k.path}
        '')}
      '';

    assertions = [{ assertion = if cfg.settings.X11Forwarding then cfgc.setXAuthLocation else true;
                    message = "cannot enable X11 forwarding without setting xauth location";}
                  (let
                    duplicates =
                      # Filter out the groups with more than 1 element
                      lib.filter (l: lib.length l > 1) (
                        # Grab the groups, we don't care about the group identifiers
                        lib.attrValues (
                          # Group the settings that are the same in lower case
                          lib.groupBy lib.strings.toLower (attrNames cfg.settings)
                        )
                      );
                    formattedDuplicates = lib.concatMapStringsSep ", " (dupl: "(${lib.concatStringsSep ", " dupl})") duplicates;
                  in
                  {
                    assertion = lib.length duplicates == 0;
                    message = ''Duplicate sshd config key; does your capitalization match the option's? Duplicate keys: ${formattedDuplicates}'';
                  })]
      ++ forEach cfg.listenAddresses ({ addr, ... }: {
        assertion = addr != null;
        message = "addr must be specified in each listenAddresses entry";
      });
  };

}
