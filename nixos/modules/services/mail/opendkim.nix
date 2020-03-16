{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.opendkim;

  defaultSock = "local:/run/opendkim/opendkim.sock";

  configFile = pkgs.writeText "opendkim.conf" (with generators;
    # TODO: Define a format as in https://github.com/NixOS/nixpkgs/pull/75584
    toKeyValue { mkKeyValue = mkKeyValueDefault {} " "; } (filterAttrs (name: value: value != null) cfg.settings)
  );

in {
  imports = [
    (mkRenamedOptionModule [ "services" "opendkim" "keyFile" ] [ "services" "opendkim" "keyPath" ])
    (mkRemovedOptionModule [ "services" "opendkim" "configFile" ] "Replaced with services.opendkim.settings")
  ];

  ###### interface

  options = {

    services.opendkim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the OpenDKIM sender authentication system.";
      };

      socket = mkOption {
        type = types.str;
        default = defaultSock;
        description = "Socket which is used for communication with OpenDKIM.";
      };

      user = mkOption {
        type = types.str;
        default = "opendkim";
        description = "User for the daemon.";
      };

      group = mkOption {
        type = types.str;
        default = "opendkim";
        description = "Group for the daemon.";
      };

      domains = mkOption {
        type = types.str;
        default = "csl:${config.networking.hostName}";
        example = "csl:example.com,mydomain.net";
        description = ''
          Local domains set (see <citerefentry><refentrytitle>opendkim
          </refentrytitle><manvolnum>8</manvolnum></citerefentry> for more
          information on datasets). Messages from them are signed, not verified.
        '';
      };

      keyPath = mkOption {
        type = types.path;
        description = ''
          The path that opendkim should put its generated private keys into.
          The DNS settings will be found in this directory with the name selector.txt.
        '';
        default = "/var/lib/opendkim/keys";
      };

      selector = mkOption {
        type = types.str;
        description = "Selector to use when signing.";
      };

      settings = mkOption {
        type = with types; lazyAttrsOf (nullOr (oneOf [ bool str int ]));
        example = literalExample ''
          {
            Canonicalization = "relaxed/simple";
            LogWhy = true;
            MilterDebug = 6;
            UMask = "0002";
          }
        '';
        description = ''
          Configuration for opendkim, see <citerefentry><refentrytitle>
          opendkim.conf </refentrytitle><manvolnum>5</manvolnum></citerefentry>
          or <link xlink:href="http://www.opendkim.org/opendkim.conf.5.html"/>
          for supported values. A value of <literal>null</literal> represents an
          unset value. Note that only if <literal>settings.KeyTable</literal> is
          unset, <option>domains</option> and <option>selector</option> are
          applied.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.opendkim.settings = {
      Background = false;
      Syslog = true;

      UMask = mkDefault "0002";

      # Set this to null so we don't have to check for this key existing below
      KeyTable = mkOptionDefault null;

      # TODO: Use https://github.com/NixOS/nixpkgs/pull/82743 in the future
      Socket = mkDefault cfg.socket;
      # These settings wouldn't have any effect when KeyTable is set
      Domain = mkIf (cfg.settings.KeyTable == null) (mkDefault cfg.domains);
      Selector = mkIf (cfg.settings.KeyTable == null) (mkDefault cfg.selector);
      KeyFile = mkIf (cfg.settings.KeyTable == null && cfg.settings.Selector != null)
        (mkDefault "${cfg.keyPath}/${cfg.settings.Selector}.private");
    };

    users.users = optionalAttrs (cfg.user == "opendkim") {
      opendkim = {
        group = cfg.group;
        uid = config.ids.uids.opendkim;
      };
    };

    users.groups = optionalAttrs (cfg.group == "opendkim") {
      opendkim.gid = config.ids.gids.opendkim;
    };

    environment.systemPackages = [ pkgs.opendkim ];

    systemd.tmpfiles.rules = [
      "d '${cfg.keyPath}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.opendkim = {
      description = "OpenDKIM signing and verification daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = mkIf (cfg.settings.Selector != null) ''
        cd "${cfg.keyPath}"
        if ! test -f ${cfg.settings.Selector}.private; then
          ${pkgs.opendkim}/bin/opendkim-genkey -s ${cfg.settings.Selector} -d all-domains-generic-key
          echo "Generated OpenDKIM key! Please update your DNS settings:\n"
          echo "-------------------------------------------------------------"
          cat ${cfg.settings.Selector}.txt
          echo "-------------------------------------------------------------"
        fi
      '';

      serviceConfig = {
        ExecStart = "${pkgs.opendkim}/bin/opendkim -x ${configFile}";
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = optional (cfg.settings.Socket == defaultSock) "opendkim";
      };
    };

  };
}
