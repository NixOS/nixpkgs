{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg  = config.services.openssh;
  cfgc = config.programs.ssh;

  nssModulesPath = config.system.nssModules.path;

  permitRootLoginCheck = v:
    v == "yes" ||
    v == "without-password" ||
    v == "forced-commands-only" ||
    v == "no";

  hostKeyTypeNames = {
    dsa1024  = "dsa";
    rsa1024  = "rsa";
    ecdsa521 = "ecdsa";
  };

  hostKeyTypeBits = {
    dsa1024  = 1024;
    rsa1024  = 1024;
    ecdsa521 = 521;
  };

  hktn = attrByPath [cfg.hostKeyType] (throw "unknown host key type `${cfg.hostKeyType}'") hostKeyTypeNames;
  hktb = attrByPath [cfg.hostKeyType] (throw "unknown host key type `${cfg.hostKeyType}'") hostKeyTypeBits;

  userOptions = {
    openssh.authorizedKeys = {

      preserveExistingKeys = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If this option is enabled, the keys specified in
          <literal>keys</literal> and/or <literal>keyFiles</literal> will be
          placed in a special section of the user's authorized_keys file
          and any existing keys will be preserved. That section will be
          regenerated each time NixOS is activated. However, if
          <literal>preserveExisting</literal> isn't enabled, the complete file
          will be generated, and any user modifications will be wiped out.
        '';
      };

      keys = mkOption {
        type = types.listOf types.string;
        default = [];
        description = ''
          A list of verbatim OpenSSH public keys that should be inserted into the
          user's authorized_keys file. You can combine the <literal>keys</literal> and
          <literal>keyFiles</literal> options.
        '';
      };

      keyFiles = mkOption {
        #type = types.listOf types.string;
        default = [];
        description = ''
          A list of files each containing one OpenSSH public keys that should be
          inserted into the user's authorized_keys file. You can combine
          the <literal>keyFiles</literal> and
          <literal>keys</literal> options.
        '';
      };

    };
  };

  mkAuthkeyScript =
    let
      marker1 = "### NixOS will regenerate this line and every line below it.";
      marker2 = "### NixOS will regenerate this file. Do not edit!";
      users = map (userName: getAttr userName config.users.extraUsers) (attrNames config.users.extraUsers);
      usersWithKeys = flip filter users (u:
        length u.openssh.authorizedKeys.keys != 0 || length u.openssh.authorizedKeys.keyFiles != 0
      );
      userLoop = flip concatMapStrings usersWithKeys (u:
        let
          authKeys = concatStringsSep "," u.openssh.authorizedKeys.keys;
          authKeyFiles = concatStringsSep "," u.openssh.authorizedKeys.keyFiles;
          preserveExisting = if u.openssh.authorizedKeys.preserveExistingKeys then "true" else "false";
        in ''
          mkAuthKeysFile "${u.name}" "${authKeys}" "${authKeyFiles}" "${preserveExisting}"
        ''
      );
    in ''
      mkAuthKeysFile() {
        local userName="$1"
        local authKeys="$2"
        local authKeyFiles="$3"
        local preserveExisting="$4"
        IFS=","

        for f in $authKeyFiles; do
          if [ -f "$f" ]; then
            authKeys="$(${pkgs.coreutils}/bin/cat "$f"),$authKeys"
          fi
        done

        if [ -n "$authKeys" ]; then
          eval authfile=~$userName/.ssh/authorized_keys
          ${pkgs.coreutils}/bin/mkdir -p "$(dirname $authfile)"
          ${pkgs.coreutils}/bin/touch "$authfile"
          if [ "$preserveExisting" == "false" ]; then
            rm -f "$authfile"
            authKeys="${marker2},$authKeys"
          else
            ${pkgs.gnused}/bin/sed -i '/^### NixOS.*$/,$d' "$authfile"
            authKeys="${marker1},$authKeys"
          fi
          for key in $authKeys; do ${pkgs.coreutils}/bin/echo "$key" >> "$authfile"; done
        fi

        unset IFS
      }
      ${userLoop}
    '';


in

{

  ###### interface

  options = {

    services.openssh = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the OpenSSH secure shell daemon, which
          allows secure remote logins.
        '';
      };

      forwardX11 = mkOption {
        default = cfgc.setXAuthLocation;
        description = ''
          Whether to allow X11 connections to be forwarded.
        '';
      };

      allowSFTP = mkOption {
        default = true;
        description = ''
          Whether to enable the SFTP subsystem in the SSH daemon.  This
          enables the use of commands such as <command>sftp</command> and
          <command>sshfs</command>.
        '';
      };

      permitRootLogin = mkOption {
        default = "yes";
        check = permitRootLoginCheck;
        description = ''
          Whether the root user can login using ssh. Valid values are
          <literal>yes</literal>, <literal>without-password</literal>,
          <literal>forced-commands-only</literal> or
          <literal>no</literal>.
          If without-password doesn't work try <literal>yes</literal>.
        '';
      };

      gatewayPorts = mkOption {
        default = "no";
        description = ''
          Specifies whether remote hosts are allowed to connect to
          ports forwarded for the client.  See
          <citerefentry><refentrytitle>sshd_config</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>.
        '';
      };

      ports = mkOption {
        default = [22];
        description = ''
          Specifies on which ports the SSH daemon listens.
        '';
      };

      usePAM = mkOption {
        default = true;
        description = ''
          Specifies whether the OpenSSH daemon uses PAM to authenticate
          login attempts.
        '';
      };

      passwordAuthentication = mkOption {
        default = true;
        description = ''
          Specifies whether password authentication is allowed. Note
          that setting this value to <literal>false</literal> is most
          probably not going to have the desired effect unless
          <literal>usePAM</literal> is disabled as well.
        '';
      };

      hostKeyType = mkOption {
        default = "dsa1024";
        description = "Type of host key to generate (dsa1024/rsa1024/ecdsa521)";
      };

      extraConfig = mkOption {
        default = "";
        description = "Verbatim contents of <filename>sshd_config</filename>.";
      };

    };

    users.extraUsers = mkOption {
      options = [ userOptions ];
    };

  };


  ###### implementation

  config = mkIf config.services.openssh.enable {

    users.extraUsers = singleton
      { name = "sshd";
        uid = config.ids.uids.sshd;
        description = "SSH privilege separation user";
        home = "/var/empty";
      };

    environment.etc = singleton
      { source = "${pkgs.openssh}/etc/ssh/moduli";
        target = "ssh/moduli";
      };

    jobs.sshd = {

        description = "OpenSSH server";

        startOn = "started network-interfaces";

        environment = {
          LD_LIBRARY_PATH = nssModulesPath;
          # Duplicated from bashrc. OpenSSH needs a patch for this.
          LOCALE_ARCHIVE = "/var/run/current-system/sw/lib/locale/locale-archive";
        };

        preStart =
          ''
            ${mkAuthkeyScript}

            mkdir -m 0755 -p /etc/ssh

            if ! test -f /etc/ssh/ssh_host_${hktn}_key; then
                ${pkgs.openssh}/bin/ssh-keygen -t ${hktn} -b ${toString hktb} -f /etc/ssh/ssh_host_${hktn}_key -N ""
            fi
          '';

        daemonType = "fork";

        exec =
          ''
            ${pkgs.openssh}/sbin/sshd -h /etc/ssh/ssh_host_${hktn}_key \
              -f ${pkgs.writeText "sshd_config" cfg.extraConfig}
          '';
      };

    networking.firewall.allowedTCPPorts = cfg.ports;

    services.openssh.extraConfig =
      ''
        Protocol 2

        UsePAM ${if cfg.usePAM then "yes" else "no"}

        ${concatMapStrings (port: ''
          Port ${toString port}
        '') cfg.ports}

        ${optionalString cfgc.setXAuthLocation ''
            XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        ''}

        ${if cfg.forwardX11 then ''
          X11Forwarding yes
        '' else ''
          X11Forwarding no
        ''}

        ${optionalString cfg.allowSFTP ''
          Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
        ''}

        PermitRootLogin ${cfg.permitRootLogin}
        GatewayPorts ${cfg.gatewayPorts}
        PasswordAuthentication ${if cfg.passwordAuthentication then "yes" else "no"}
      '';

    assertions = [{ assertion = if cfg.forwardX11 then cfgc.setXAuthLocation else true; 
                    message = "cannot enable X11 forwarding without setting xauth location";}];
  };

}
