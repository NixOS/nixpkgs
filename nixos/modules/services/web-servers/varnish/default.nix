{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.varnish;

  # Varnish has very strong opinions and very complicated code around handling
  # the stateDir. After a lot of back and forth, we decided that we a)
  # do not want a configurable option here, as most of the handling depends
  # on the version and the compile time options. Putting everything into
  # /var/run (RAM backed) is absolutely recommended by Varnish anyways.
  # We do need to pay attention to the version-dependend variations, though!
  stateDir =
    if
      (lib.versionOlder cfg.package.version "7")
    # Remove after Varnish 6.0 is gone. In 6.0 varnishadm always appends the
    # hostname (by default) and can't be nudged to not use any name. This has
    # long changed by 7.5 and can be used without the host name.
    then
      "/var/run/varnish/${config.networking.hostName}"
    # Newer varnish uses this:
    else
      "/var/run/varnishd";

  commandLine =
    "-f ${pkgs.writeText "default.vcl" cfg.config}"
    +
      lib.optionalString (cfg.extraModules != [ ])
        " -p vmod_path='${
           lib.makeSearchPathOutput "lib" "lib/varnish/vmods" ([ cfg.package ] ++ cfg.extraModules)
         }' -r vmod_path";
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "varnish"
      "stateDir"
    ] "The `stateDir` option never was functional or useful. varnish uses compile-time settings.")
  ];

  options = {
    services.varnish = {
      enable = lib.mkEnableOption "Varnish Server";

      enableConfigCheck = lib.mkEnableOption "checking the config during build time" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "varnish" { };

      http_address = lib.mkOption {
        type = lib.types.str;
        default = "*:6081";
        description = ''
          HTTP listen address and port.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Verbatim default.vcl configuration.
        '';
      };

      extraModules = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.varnishPackages.geoip ]";
        description = ''
          Varnish modules (except 'std').
        '';
      };

      extraCommandLine = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "-s malloc,256M";
        description = ''
          Command line switches for varnishd (run 'varnishd -?' to get list of options)
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.varnish = {
      description = "Varnish";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        PermissionsStartOnly = true;
        ExecStart = "${cfg.package}/sbin/varnishd -a ${cfg.http_address} -n ${stateDir} -F ${cfg.extraCommandLine} ${commandLine}";
        Restart = "always";
        RestartSec = "5s";
        User = "varnish";
        Group = "varnish";
        RuntimeDirectory = lib.removePrefix "/var/run/" stateDir;
        AmbientCapabilities = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNOFILE = 131072;
      };
    };

    environment.systemPackages = [ cfg.package ];

    # check .vcl syntax at compile time (e.g. before nixops deployment)
    system.checks = lib.mkIf cfg.enableConfigCheck [
      (pkgs.runCommand "check-varnish-syntax" { } ''
        ${cfg.package}/bin/varnishd -C ${commandLine} 2> $out || (cat $out; exit 1)
      '')
    ];

    users.users.varnish = {
      group = "varnish";
      uid = config.ids.uids.varnish;
    };

    users.groups.varnish.gid = config.ids.uids.varnish;
  };
}
