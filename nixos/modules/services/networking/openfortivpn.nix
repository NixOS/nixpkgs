{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.openfortivpn;

  settingsType =
    with lib.types;
    attrsOf (oneOf [
      bool
      int
      str
      (listOf str)
    ]);

  formatValue =
    v:
    if lib.isBool v then
      if v then "1" else "0"
    else if lib.isList v then
      lib.concatStringsSep "\n" (map (x: "${v} = ${x}") v)
    else
      toString v;

  configContent = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "${k} = ${formatValue v}") cfg.settings
  );

  configFile = pkgs.writeText "openfortivpn.cfg" configContent;

in
{
  options = {
    services.openfortivpn = {
      enable = lib.mkEnableOption "OpenFortiVPN client";

      package = lib.mkPackageOption pkgs "openfortivpn" { };

      settings = lib.mkOption {
        type = settingsType;
        default = { };
        description = lib.mdDoc ''
          OpenFortiVPN configuration options.
          The 'host', 'port', and at least one 'trusted-cert' are mandatory.

          For a full list of options, see `man openfortivpn(1)`.
        '';
        example = lib.literalExpression ''
          {
            host = "vpn.example.com";
            port = 443;
            username = "user";
            trusted-cert = [
              "42c1e812b8657f89c777cf2f450ce930917791959c65ff2c6931c7f3075143cf"
              "othercertificatedigest6631bf..."
            ];
            set-dns = false;
            pppd-use-peerdns = false;
            persistent = 60;
          }
        '';
      };

      extraOptions = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = lib.mdDoc ''
          Additional command line options to pass to openfortivpn.
        '';
        example = [
          "--no-ftm-push"
          "--cipher-list=AES256-GCM-SHA384"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings ? host;
        message = "OpenFortiVPN requires a host to be configured in services.openfortivpn.settings.host";
      }
      {
        assertion = cfg.settings ? "trusted-cert";
        message = "OpenFortiVPN requires at least one trusted certificate in services.openfortivpn.settings.trusted-cert";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.openfortivpn = {
      description = "OpenFortiVPN Client";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${lib.getExe cfg.package}"
            "-c ${configFile}"
          ]
          ++ cfg.extraOptions
        );
        Restart = "on-failure";
      };
    };
  };
}
