{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.zeyple;
  ini = pkgs.formats.ini { };

  gpgHome = pkgs.runCommand "zeyple-gpg-home" { } ''
    mkdir -p $out
    for file in ${lib.concatStringsSep " " cfg.keys}; do
      ${config.programs.gnupg.package}/bin/gpg --homedir="$out" --import "$file"
    done

    # Remove socket files
    rm -f $out/S.*
  '';
in
{
  options.services.zeyple = {
    enable = lib.mkEnableOption "Zeyple, an utility program to automatically encrypt outgoing emails with GPG";

    user = lib.mkOption {
      type = lib.types.str;
      default = "zeyple";
      description = ''
        User to run Zeyple as.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise the sysadmin is responsible for
        ensuring the user exists.
        :::
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "zeyple";
      description = ''
        Group to use to run Zeyple.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise the sysadmin is responsible for
        ensuring the user exists.
        :::
      '';
    };

    settings = lib.mkOption {
      type = ini.type;
      default = { };
      description = ''
        Zeyple configuration. refer to
        <https://github.com/infertux/zeyple/blob/master/zeyple/zeyple.conf.example>
        for details on supported values.
      '';
    };

    keys = lib.mkOption {
      type = with lib.types; listOf path;
      description = "List of public key files that will be imported by gpg.";
    };

    rotateLogs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable rotation of log files.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.optionalAttrs (cfg.group == "zeyple") { "${cfg.group}" = { }; };
    users.users = lib.optionalAttrs (cfg.user == "zeyple") {
      "${cfg.user}" = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    services.zeyple.settings = {
      zeyple = lib.mapAttrs (name: lib.mkDefault) {
        log_file = "/var/log/zeyple/zeyple.log";
        force_encrypt = true;
      };

      gpg = lib.mapAttrs (name: lib.mkDefault) { home = "${gpgHome}"; };

      relay = lib.mapAttrs (name: lib.mkDefault) {
        host = "localhost";
        port = 10026;
      };
    };

    environment.etc."zeyple.conf".source = ini.generate "zeyple.conf" cfg.settings;

    systemd.tmpfiles.settings."10-zeyple".${cfg.settings.zeyple.log_file}.f = {
      inherit (cfg) user group;
      mode = "0600";
    };

    services.logrotate = lib.mkIf cfg.rotateLogs {
      enable = true;
      settings.zeyple = {
        files = cfg.settings.zeyple.log_file;
        frequency = "weekly";
        rotate = 5;
        compress = true;
        copytruncate = true;
      };
    };

    services.postfix.extraMasterConf = ''
      zeyple    unix  -       n       n       -       -       pipe
        user=${cfg.user} argv=${pkgs.zeyple}/bin/zeyple ''${recipient}

      localhost:${toString cfg.settings.relay.port} inet  n       -       n       -       10      smtpd
        -o content_filter=
        -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters
        -o smtpd_helo_restrictions=
        -o smtpd_client_restrictions=
        -o smtpd_sender_restrictions=
        -o smtpd_recipient_restrictions=permit_mynetworks,reject
        -o mynetworks=127.0.0.0/8,[::1]/128
        -o smtpd_authorized_xforward_hosts=127.0.0.0/8,[::1]/128
    '';

    services.postfix.settings.main.content_filter = "zeyple";
  };
}
