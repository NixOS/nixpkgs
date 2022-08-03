{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.initrd.network.ssh;

in

{

  options.boot.initrd.network.ssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Start SSH service during initrd boot. It can be used to debug failing
        boot on a remote server, enter pasphrase for an encrypted partition etc.
        Service is killed when stage-1 boot is finished.

        The sshd configuration is largely inherited from
        {option}`services.openssh`.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 22;
      description = lib.mdDoc ''
        Port on which SSH initrd service should listen.
      '';
    };

    shell = mkOption {
      type = types.str;
      default = "/bin/ash";
      description = lib.mdDoc ''
        Login shell of the remote user. Can be used to limit actions user can do.
      '';
    };

    hostKeys = mkOption {
      type = types.listOf (types.either types.str types.path);
      default = [];
      example = [
        "/etc/secrets/initrd/ssh_host_rsa_key"
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];
      description = ''
        Specify SSH host keys to import into the initrd.

        To generate keys, use
        <citerefentry><refentrytitle>ssh-keygen</refentrytitle><manvolnum>1</manvolnum></citerefentry>:

        <screen>
        <prompt># </prompt>ssh-keygen -t rsa -N "" -f /etc/secrets/initrd/ssh_host_rsa_key
        <prompt># </prompt>ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key
        </screen>

        <warning>
          <para>
            Unless your bootloader supports initrd secrets, these keys
            are stored insecurely in the global Nix store. Do NOT use
            your regular SSH host private keys for this purpose or
            you'll expose them to regular users!
          </para>
          <para>
            Additionally, even if your initrd supports secrets, if
            you're using initrd SSH to unlock an encrypted disk then
            using your regular host keys exposes the private keys on
            your unencrypted boot partition.
          </para>
        </warning>
      '';
    };

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = config.users.users.root.openssh.authorizedKeys.keys;
      defaultText = literalExpression "config.users.users.root.openssh.authorizedKeys.keys";
      description = lib.mdDoc ''
        Authorized keys for the root user on initrd.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc "Verbatim contents of {file}`sshd_config`.";
    };
  };

  imports =
    map (opt: mkRemovedOptionModule ([ "boot" "initrd" "network" "ssh" ] ++ [ opt ]) ''
      The initrd SSH functionality now uses OpenSSH rather than Dropbear.

      If you want to keep your existing initrd SSH host keys, convert them with
        $ dropbearconvert dropbear openssh dropbear_host_$type_key ssh_host_$type_key
      and then set options.boot.initrd.network.ssh.hostKeys.
    '') [ "hostRSAKey" "hostDSSKey" "hostECDSAKey" ];

  config = let
    # Nix complains if you include a store hash in initrd path names, so
    # as an awful hack we drop the first character of the hash.
    initrdKeyPath = path: if isString path
      then path
      else let name = builtins.baseNameOf path; in
        builtins.unsafeDiscardStringContext ("/etc/ssh/" +
          substring 1 (stringLength name) name);

    sshdCfg = config.services.openssh;

    sshdConfig = ''
      Port ${toString cfg.port}

      PasswordAuthentication no
      ChallengeResponseAuthentication no

      ${flip concatMapStrings cfg.hostKeys (path: ''
        HostKey ${initrdKeyPath path}
      '')}

      KexAlgorithms ${concatStringsSep "," sshdCfg.kexAlgorithms}
      Ciphers ${concatStringsSep "," sshdCfg.ciphers}
      MACs ${concatStringsSep "," sshdCfg.macs}

      LogLevel ${sshdCfg.logLevel}

      ${if sshdCfg.useDns then ''
        UseDNS yes
      '' else ''
        UseDNS no
      ''}

      ${cfg.extraConfig}
    '';
  in mkIf (config.boot.initrd.network.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.authorizedKeys != [];
        message = "You should specify at least one authorized key for initrd SSH";
      }

      {
        assertion = cfg.hostKeys != [];
        message = ''
          You must now pre-generate the host keys for initrd SSH.
          See the boot.initrd.network.ssh.hostKeys documentation
          for instructions.
        '';
      }
    ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.openssh}/bin/sshd
      cp -pv ${pkgs.glibc.out}/lib/libnss_files.so.* $out/lib
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      # sshd requires a host key to check config, so we pass in the test's
      tmpkey="$(mktemp initrd-ssh-testkey.XXXXXXXXXX)"
      cp "${../../../tests/initrd-network-ssh/ssh_host_ed25519_key}" "$tmpkey"
      # keys from Nix store are world-readable, which sshd doesn't like
      chmod 600 "$tmpkey"
      echo -n ${escapeShellArg sshdConfig} |
        $out/bin/sshd -t -f /dev/stdin \
        -h "$tmpkey"
      rm "$tmpkey"
    '';

    boot.initrd.network.postCommands = ''
      echo '${cfg.shell}' > /etc/shells
      echo 'root:x:0:0:root:/root:${cfg.shell}' > /etc/passwd
      echo 'sshd:x:1:1:sshd:/var/empty:/bin/nologin' >> /etc/passwd
      echo 'passwd: files' > /etc/nsswitch.conf

      mkdir -p /var/log /var/empty
      touch /var/log/lastlog

      mkdir -p /etc/ssh
      echo -n ${escapeShellArg sshdConfig} > /etc/ssh/sshd_config

      echo "export PATH=$PATH" >> /etc/profile
      echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >> /etc/profile

      mkdir -p /root/.ssh
      ${concatStrings (map (key: ''
        echo ${escapeShellArg key} >> /root/.ssh/authorized_keys
      '') cfg.authorizedKeys)}

      ${flip concatMapStrings cfg.hostKeys (path: ''
        # keys from Nix store are world-readable, which sshd doesn't like
        chmod 0600 "${initrdKeyPath path}"
      '')}

      /bin/sshd -e
    '';

    boot.initrd.postMountCommands = ''
      # Stop sshd cleanly before stage 2.
      #
      # If you want to keep it around to debug post-mount SSH issues,
      # run `touch /.keep_sshd` (either from an SSH session or in
      # another initrd hook like preDeviceCommands).
      if ! [ -e /.keep_sshd ]; then
        pkill -x sshd
      fi
    '';

    boot.initrd.secrets = listToAttrs
      (map (path: nameValuePair (initrdKeyPath path) path) cfg.hostKeys);
  };

}
