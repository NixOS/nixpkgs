{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    escapeShellArgs
    flatten
    getExe
    isBool
    isList
    map
    mkEnableOption
    mkIf
    mkOption
    optional
    removeAttrs
    types
    ;

  cfg = config.services.proxydetox;

  mkTcpKeepAliveField =
    name: side:
    mkOption {
      type = with types; nullOr ints.positive;
      default = null;
      description = ''
        TCP keep alive ${name} for ${side} sockets
      '';
    };

  mkTcpKeepAlive = side: {
    time = mkTcpKeepAliveField "time (in seconds)" side;
    interval = mkTcpKeepAliveField "interval (in seconds)" side;
    retries = mkTcpKeepAliveField "retries" side;
  };

  mkArg =
    cfg: cname: aname:
    let
      val = (cfg."${cname}".enable or cfg."${cname}");
    in
    optional (val != null) (
      if isBool val then
        optional val "--${aname}"
      else if isList val then
        map (val: [
          "--${aname}"
          (toString val)
        ]) val
      else
        [
          "--${aname}"
          (toString val)
        ]
    );

  mkArgsFrom = cfg: names: flatten (map (name: mkArg cfg name name) names);

  mkArgsIgnore = cfg: blackList: mkArgsFrom cfg (attrNames (removeAttrs cfg blackList));

  mkTcpKeepAliveArgs =
    cfg: side:
    flatten (
      map (name: mkArg cfg."${side}-tcp-keepalive" name "${side}-tcp-keepalive-${name}") (
        attrNames cfg."${side}-tcp-keepalive"
      )
    );
in
{
  options.services.proxydetox = {

    enable = mkEnableOption ''
      proxydetox service, which can evaluate PAC files and
      forward to the correct parent proxy with authentication
    '';

    negotiate = mkOption {
      type = with types; either bool str;
      default = false;
      description = "Enables Negotiate (SPNEGO) authentication";
    };

    listen = mkOption {
      type = with types; listOf str;
      default = [ "127.0.0.1:3128" ];
      description = "Listening interface";
    };

    pac-file = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        PAC file to be used to decide which upstream proxy to forward the
        request (local file path, http://, or https:// URI are accepted)
      '';
    };

    my-ip-address = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Custom IP address to be returned by the myIpAddress PAC function
      '';
    };

    netrc-file = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Custom IP address to be returned by the myIpAddress PAC function
      '';
    };

    proxytunnel.enable = mkEnableOption ''
      always use CONNECT method even for http resources
    '';

    direct-fallback.enable = mkEnableOption ''
      falling back to direct connection when connecting via proxies fails
    '';

    connect-timeout = mkOption {
      type = types.ints.positive;
      default = 10;
      description = ''
        Timeout to establish a connection in fraction seconds
      '';
    };

    race-connect.enable = mkEnableOption ''
      race multiple connections at the same time
    '';

    parallel-connect = mkOption {
      type = types.ints.positive;
      default = 1;
      description = ''
        Number of connect attempts to perform in parallel
      '';
    };

    client-tcp-keepalive = mkTcpKeepAlive "client";

    server-tcp-keepalive = mkTcpKeepAlive "server";

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra arguments to proxydetox";
    };

    user = mkOption {
      type = types.str;
      default = "proxydetox";
      description = "User account under which proxydetox runs.";
    };

    group = mkOption {
      type = types.str;
      default = "proxydetox";
      description = "Group under which proxydetox runs.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.proxydetox;
      defaultText = "pkgs.proxydetox";
      description = "The proxydetox derivation to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.proxydetox = {
      description = "A http proxy with PAC files and authentication support";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        ExecStart =
          let
            genericArgs = mkArgsIgnore cfg [
              "enable"
              "client-tcp-keepalive"
              "server-tcp-keepalive"
              "extraArgs"
              "user"
              "group"
              "package"
            ];
            client-tcp-keepalive-args = mkTcpKeepAliveArgs cfg "client";
            server-tcp-keepalive-args = mkTcpKeepAliveArgs cfg "server";
            allArgs = genericArgs ++ client-tcp-keepalive-args ++ server-tcp-keepalive-args ++ cfg.extraArgs;
          in
          ''
            ${getExe cfg.package} ${escapeShellArgs allArgs}
          '';
      };
    };

    users.users = mkIf (cfg.user == "proxydetox") {
      proxydetox = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "proxydetox") {
      proxydetox = { };
    };
  };

  meta.maintainers = with lib.maintainers; [
    shved
  ];
}
