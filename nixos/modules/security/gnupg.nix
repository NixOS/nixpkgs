{ config, lib, pkgs, ... }:
let
  inherit (builtins) attrNames dirOf length match split;
  inherit (lib) types;
  inherit (config) networking;
  cfg = config.security.gnupg;
  gnupgHome = "/var/lib/gnupg/.gnupg";
  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName = name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s)
    (split "[^a-zA-Z0-9_.\\-]+" name);
in
{
options.security.gnupg = {
  store = lib.mkOption {
    type = with types; either str path;
    default = "/root/.password-store";
    description = ''
      Default base path for the <literal>gpg</literal> option
      of the <link linkend="opt-security.gnupg.secrets">secrets</link>.
      Note that you may set it up with something like:
      <literal>builtins.getEnv "PASSWORD_STORE_DIR" + "/machines/example"</literal>.
    '';
  };
  secrets = lib.mkOption {
    description = "Available secrets.";
    default = {};
    example = {
      "/root/.ssh/id_ed25519" = {};
      "knot/tsig/example.org/acme.conf" = {
        user = "knot";
      };
      "rspamd/controller/hashedPassword" = {
        pipe = "${pkgs.gnused}/bin/sed -e 's/.*/password = \"\\0\";/'";
      };
    };
    type = types.attrsOf (types.submodule ({name, config, ...}: {
      options.gpg = lib.mkOption {
        type = types.path;
        default =
          if builtins.typeOf cfg.store == "path"
          then builtins.path {
            # Load only the needed .gpg file into the Nix store.
            path = cfg.store + "/${name}.gpg";
            name = "${escapeUnitName name}.gpg";
          }
          else cfg.store + "/${name}.gpg";
        defaultText = "cfg.store + \"/\${name}.gpg\"";
        description = ''
          The path to the GnuPG-encrypted secret.
          It will be copied into the Nix store of the orchestrating and of the target system.
          It must be decipherable by an OpenPGP key within the GnuPG home <filename>${gnupgHome}</filename>.
          Defaults to the name of the secret,
          prefixed by the path of the <link linkend="opt-security.gnupg.store">store</link>
          and suffixed by <filename>.gpg</filename>.
        '';
      };

      options.mode = lib.mkOption {
        type = types.str;
        default = "400";
        description = ''
          Permission mode of the secret <literal>path</literal>.
        '';
      };

      options.user = lib.mkOption {
        type = types.str;
        default = "root";
        description = ''
          Owner of the secret <literal>path</literal>.
        '';
      };

      options.group = lib.mkOption {
        type = types.str;
        default = "root";
        description = ''
          Group of the secret <literal>path</literal>.
        '';
      };

      options.pipe = lib.mkOption {
        type = types.nullOr types.lines;
        default = null;
        apply = lib.mapNullable (pkgs.writeShellScript "pipe");
        description = ''
          Shell script taking the deciphered secret on its standard input
          and which must put on its standard output
          the actual secret material to be installed.
          This allows to decorate the secret with non-secret bits.
        '';
      };

      options.path = lib.mkOption {
        type = types.str;
        default = name;
        apply = p: if match "^/.*" p == null then "/run/keys/gnupg/"+p+"/file" else p;
        description = ''
          The path on the target system where the secret is installed to.
          Defaults to the name of the secret,
          prefixed by <filename>/run/keys/gnupg/</filename>
          and suffixed by <filename>/file</filename>,
          if non-absolute.
        '';
      };

      options.service = lib.mkOption {
        type = types.str;
        default = "secret-${escapeUnitName name}.service";
        defaultText = "secret-\${escapeUnitName name}.service";
        description = ''
          The name of the systemd service.
          Useful to put constraints like <literal>after</literal> or <literal>wants</literal>
          into services requiring this secret.
        '';
      };

      options.systemdConfig = lib.mkOption {
        type = types.attrs;
        default = {};
        example = {
          before = [ "transmission.service" ];
          wantedBy = [ "transmission.service" ];
        };
        description = ''
          Convenient option for setting extra configuration options
          of the systemd service installing the secret.
          Be sure to add a <code>wantedBy=</code> statement,
          otherwise the secret's service won't be started if needed.
          You can use <code>wantedBy = ["multi-user.target"]</code>
          if the secret is not used by another systemd service.
        '';
      };
    }));
  };
  agent = {
    enable = lib.mkEnableOption ''gpg-agent for decrypting secrets.

      Otherwise, you'll have to <link xlink:href="https://wiki.gnupg.org/AgentForwarding">forward a gpg-agent</link>
      using its <literal>agent-extra-socket</literal>, eg.:
      <screen>
      <prompt>$ </prompt>ssh -nNT gnupg@example.org -o StreamLocalBindUnlink=yes -R ${gnupgHome}/S.gpg-agent:$(gpgconf --list-dirs agent-extra-socket)
      </screen>
    '';

    flags = lib.mkOption {
      type = types.listOf types.str;
      default = [
        "--default-cache-ttl" "600"
        "--max-cache-ttl" "7200"
      ];
      description = ''
        Extra flags passed to the <literal>gpg-agent</literal>
        used to decrypt secrets.
      '';
    };

    keyring = lib.mkOption {
      description = ''
        Map OpenPGP keys to be sent to the <literal>gpg-agent</literal> service, by their keygrip.
        To get the keygrip of a primary key or subkey,
        use: <code>gpg --list-keys --with-keygrip --with-keygrip</code>.
      '';
      default = {};
      type = types.attrsOf (types.submodule ({name, config, ...}: {
        options.passwordFile = lib.mkOption {
          type = with types; nullOr path;
          description = ''
            Absolute path to a cleartext password of an OpenPGP key on the target system,
            if non-<code>null</code>, all decrypting services
            will try to preset this password into <literal>gpg-agent.service</literal>'s cache
            before trying their decryption, effectively enabling unattended decryption.
            Note that the parent directory must exist
            if the sending script is used to write this file.
          '';
          default = null;
          example = "/root/.gnupg.81956F1D9C7CD94AD29EA8D0FB89C52FF537E51E.txt";
        };

        options.passwordGpg = lib.mkOption {
          type = with types; nullOr (either path str);
          description = ''
            Encrypted password of an OpenPGP key, enabling attended decryption
            or sending the password on disk for unattended decryption
            (if <literal>passwordFile</literal> is also set).
            Set to <code>null</code> to send only the public part.
            Non-absolute paths are relative to <xref linkend="opt-security.gnupg.store"/>.
          '';
          default = "keygrip/${name}.gpg";
          apply = lib.mapNullable (p:
            # Never load the password's .gpg into the Nix store.
            let s = toString p; in
            if match "^/.*" s == null
            then cfg.store+"/"+s else s
          );
        };

        options.ssh = lib.mkOption {
          type = with types; listOf str;
          description = ''
            OpenSSH command to send the OpenPGP key and its password.
            Defaults to an ssh connection to the <code>root</code> of the target machine,
            but any other member of the <code>gnupg</code> group can be used.
          '';
          apply = lib.concatStringsSep " ";
          default = [ "ssh" "-o" "StrictHostKeyChecking=yes" "\"\${TARGET:-root@${networking.hostName}.${networking.domain}}\"" ];
          defaultText = "ssh -o StrictHostKeyChecking=yes \"\${TARGET:-root@\${config.networking.hostName}.\${config.networking.domain}}\"";
        };

        options.send = lib.mkOption {
          type = types.lines;
          description = ''
            Convenient script to send an OpenPGP key, and its password to the gpg-agent.
            Example of use:
            <screen>
            <prompt>$ </prompt>nix run .#nixosConfigurations.''${hostName}.config.security.gnupg.agent.keyring.''${keygrip}.send
            </screen>
            Because <code>gpg-agent.service</code> will not be restarted by a configuration switch,
            sending the key's password is usually done between <code>nix copy</code>
            and <code>switch-to-configuration</code>.
            Note however that when <code>gpg-agent.service</code> is not running
            (for instance because it has just been enabled in the configuration)
            then the sending can't possibly work, and the configuration switch will fail
            waiting to start secrets' units.
            In that case you can abort the configuration switch once <code>gpg-agent.service</code>
            is running and relaunch the install thereafter.
          '';
          # Beware no to put a dash in "keygrip${name}"
          # because ${name} can start with a digit,
          # causing `nix run` to remove that part and fail to find the executable.
          apply = pkgs.writeShellScriptBin "gnupg-agent-send-keygrip${name}";
        };

        options.enablePrimaryKey = lib.mkEnableOption "sending of the secret part of the primary key";

        config = {
          send = ''
              set -o pipefail
              export PATH=''${PATH}:${lib.makeBinPath [ pkgs.gnupg pkgs.openssh ]}
              set -eu
            '' +
            lib.optionalString (cfg.secrets != {}) (if config.passwordGpg == null
            then ''
              echo >&2 "gpg-agent: keygrip ${name}: sending public key into ${gnupgHome}"
              gpg --batch --export '&${name}' |
              ${config.ssh} ${pkgs.gnupg}/bin/gpg --batch \
                --homedir ${gnupgHome} --no-permission-warning --no-autostart --import
            ''
            else ''
              send () {
                echo >&2 "gpg-agent: keygrip ${name}: sending secret key into ${gnupgHome}"
                gpg --decrypt '${config.passwordGpg}' |
                gpg --batch --pinentry-mode loopback --passphrase-fd 0 --armor \
                  --export-secret-${lib.optionalString (!config.enablePrimaryKey) "sub"}keys '&${name}' |
                ${config.ssh} ${pkgs.gnupg}/bin/gpg --batch --pinentry-mode loopback \
                  --homedir ${gnupgHome} --no-permission-warning --no-autostart --import

                echo >&2 "gpg-agent: keygrip ${name}: sending password into cache."
                gpg --decrypt '${config.passwordGpg}' |
                ${config.ssh} ${pkgs.gnupg}/libexec/gpg-preset-passphrase --homedir ${gnupgHome} --preset '${name}'
              }
              echo >&2 "gpg-agent: keygrip ${name}: checking password cache."
              ${config.ssh} LANG=C ${pkgs.gnupg}/bin/gpg-connect-agent --no-autostart --homedir ${gnupgHome} \
                "'keyinfo --list'" /bye 2>&1 |
              while IFS= read -r line; do
                case "$line" in
                  ("gpg-connect-agent: no gpg-agent running in this session")
                    echo >&2 "gpg-agent: no gpg-agent.service active on target"
                    echo >&2 "gpg-agent: be sure to first apply \`security.gnupg.agent.enable'"
                    echo >&2 "gpg-agent: and then add secrets into \`security.gnupg.secrets'."
                    exit 0;;
                  ("S KEYINFO ${name} "?" "?" "?" 1 "*)
                    echo >&2 "gpg-agent: keygrip ${name}: password already in remote cache, not sending."
                    exit 0;;
                  ("S KEYINFO ${name} "?" "?" "?" - "*)
                    echo >&2 "gpg-agent: keygrip ${name}: password not in remote cache, sending."
                    send
                    exit 0;;
                  (OK)
                    echo >&2 "gpg-agent: keygrip ${name}: cannot find key in remote keyring, sending."
                    send
                    exit 0;;
                esac
              done
            '' + lib.optionalString (config.passwordFile != null) ''
              echo >&2 "gpg-agent: keygrip ${name}: sending password into file: ${lib.escapeShellArg config.passwordFile}"
              gpg --decrypt '${config.passwordGpg}' |
              ${config.ssh} ${pkgs.coreutils}/bin/install -m 400 /dev/stdin ${lib.escapeShellArg config.passwordFile}
            '');
        };
      }));
    };

    sendKeys = lib.mkOption {
      type = types.lines;
      apply = pkgs.writeShellScriptBin "gnupg-agent-sendKeys";
      default = "true";
      description = ''
        Send all keys in <xref linkend="opt-security.gnupg.agent.keyring"/>.
        Example of use:
        <screen>
        <prompt>$ </prompt>nix run .#nixosConfigurations.''${hostName}.config.security.gnupg.agent.sendKeys
        </screen>
      '';
    };
  };
};
config = lib.mkMerge [
  (lib.mkIf cfg.agent.enable {
    # Because /run/user/$UID is wiped out by pam_systemd when a user logouts,
    # systemd.services.gpg-agent cannot put its socket in
    # the path expected by gpg: /run/user/$UID/gnupg/d.wq3hn19d57wqmzg8beqhttrt
    # derived from gnupgHome, since this removal would kill gpg-agent.
    #
    # Unfortunately, for reaching such a persistent gpg-agent,
    # GPG_AGENT_INFO can no longer be used as it is ignored with gpg >= 2.1,
    # hence three different workarounds are done here to make gpg to always connect
    # to the socket at ${gnupgHome}/S.gpg-agent:
    # - For gpg-agent,
    #   the workaround is to use --supervised mode
    #   to pass it the socket in the persistent directory gnupgHome.
    # - For any user able to login,
    #   the problem is that on its login pam_systemd is mounting a fresh tmpfs on /run/user/$UID
    #   causing gpg to be able to launch a new gpg-agent using a socket in /run/user/$UID/gnupg/,
    #   the workaround is to set wrong perms on /run/user/$UID/gnupg/d.wq3hn19d57wqmzg8beqhttrt
    #   just when /run/user/$UID is mounted, by overriding user-runtime-dir@.service
    # - For secret decrypting services,
    #   the workaround is to use InaccessiblePaths= to keep /run/user/0/gnupg empty.
    systemd.sockets.gpg-agent = {
      description = "Socket for gpg-agent";
      wantedBy = ["sockets.target"];
      socketConfig.ListenStream = "${gnupgHome}/S.gpg-agent";
      socketConfig.SocketUser = "gnupg";
      socketConfig.SocketGroup = "gnupg";
      socketConfig.SocketMode = "0660";
    };
    systemd.services.gpg-agent = {
      description = "GnuPG agent for decrypting GnuPG-protected secrets";
      requires = ["gpg-agent.socket"];
      # Keep gpg-agent alive to preserve its cache,
      # which avoids `switch-to-configuration switch` to wait
      # for passwords to be given again.
      restartIfChanged = false;
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.gnupg}/bin/gpg-agent \
         --supervised \
         --homedir ${gnupgHome} \
         --allow-loopback-pinentry \
         --allow-preset-passphrase \
         ${lib.escapeShellArgs cfg.agent.flags}
        '';
        X-OnlyManualStart = true;
        Restart = "on-failure";
        RestartSec = 5;
        StateDirectory = ["gnupg" "gnupg/.gnupg"];
        StateDirectoryMode = "2770";
        User = "gnupg";
        Group = "gnupg";
        UMask = "007";
      };
    };
  })
  (lib.mkIf (cfg.secrets != {}) {
    environment.systemPackages = [ pkgs.gnupg ];
    systemd.packages = [
      # Here, passing by systemd.packages is kind of a hack to be able to
      # write this file which is neither writable using environment.etc
      # (because environment.etc."systemd/system".source is set)
      # nor using systemd.services (because systemd.services."user-runtime-dir@0"
      # does not exist, and should not to keep using systemd's upstream template
      # and systemd.services."user-runtime-dir@").
      (pkgs.writeTextDir "etc/systemd/system/user-runtime-dir@.service.d/override.conf" ''
        [Service]
        ExecStartPost=${pkgs.writeShellScript "redirect-gpg-agent-run-socket" ''
          uid=$(id -u "$1")
          gid=$(id -g "$1")
          install -d -o "$uid" -g "$gid" -m 700 /run/user/"$uid"/gnupg
          # Here 640 is just wrong enough to redirect gpg to ${gnupgHome}
          install -d -o "$uid" -g "$gid" -m 640 /run/user/"$uid"/gnupg/d.wq3hn19d57wqmzg8beqhttrt
        ''} %I
      '')
    ];

    users.users.gnupg = {
      description = "GnuPG agent user";
      isSystemUser = true;
      group = "gnupg";
      home = lib.removeSuffix "/.gnupg" gnupgHome;
      # Even if gpg-agent.service is not used, this directory is still used.
      createHome = true;
      # Some may prefer to send passwords using `ssh -l gnupg` instead of root.
      shell = "/run/current-system/sw/bin/bash";
    };
    users.groups.gnupg.members = [];

    systemd.services = lib.mapAttrs' (target: secret:
      lib.nameValuePair (lib.removeSuffix ".service" secret.service) (lib.mkMerge [{
        description = "Install secret ${secret.path}";
        after = lib.optional cfg.agent.enable "gpg-agent.service";
        wants = lib.optional cfg.agent.enable "gpg-agent.service";
        # No wantedBy = ["multi-user.target"]; here, to avoid decrypting unused secrets.
        script = ''
          set -o pipefail
          set -eux
          decrypt() {
            ${lib.concatStringsSep "\n" (lib.mapAttrsToList
              (keygrip: key: lib.optionalString (key.passwordFile != null) ''
                ${pkgs.gnupg}/bin/gpg-preset-passphrase --homedir ${gnupgHome} \
                 --preset ${keygrip} \
                 <${lib.escapeShellArg key.passwordFile} || true
              '') cfg.agent.keyring)
            }
            ${pkgs.gnupg}/bin/gpg --homedir ${gnupgHome} --no-autostart --batch --decrypt ${lib.escapeShellArg secret.gpg} |
            ${lib.optionalString (secret.pipe != null) (secret.pipe+" |")} \
            install -D -m '${secret.mode}' -o '${secret.user}' -g '${secret.group}' /dev/stdin ${lib.escapeShellArg secret.path}
          }
          while ! decrypt; do sleep $((1 + ($RANDOM % ${toString (length (attrNames cfg.secrets))}))); done
        '';
        serviceConfig = {
          # Note that systemd will consider the unit up only after script exits.
          Type = "oneshot";
          RemainAfterExit = true;
          PrivateTmp = true;
          InaccessiblePaths = ["-/run/user"];
          } // lib.optionalAttrs (match "^/.*" target == null) {
          RuntimeDirectory = lib.removePrefix "/run/" (dirOf secret.path);
          RuntimeDirectoryMode = "711";
          RuntimeDirectoryPreserve = false;
        };
      } secret.systemdConfig])
    ) cfg.secrets;

    security.gnupg.agent.sendKeys = lib.concatStringsSep "\n" (lib.mapAttrsToList
      (keygrip: key: key.send + "/bin/gnupg-agent-send-keygrip${keygrip}") cfg.agent.keyring);
  })
];
meta.maintainers = with lib.maintainers; [ julm ];
}
