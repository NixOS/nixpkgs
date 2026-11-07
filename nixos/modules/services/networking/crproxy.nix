{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.crproxy;

  allowImageListFile = pkgs.writeTextFile {
    name = "crproxy-allow-image-list";
    text = lib.strings.concatLines cfg.allowImageList;
  };
  useAllowImageList = (lib.length cfg.allowImageList) != 0;
  blockIPListFile = pkgs.writeTextFile {
    name = "crproxy-block-ip-list";
    text = lib.strings.concatLines cfg.blockIPList;
  };
  useBlockIPList = (lib.length cfg.blockIPList) != 0;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    concatStringsSep
    concatLists
    optionals
    literalExpression
    mkPackageOption
    ;
in
{
  options.services.crproxy = {
    enable = mkEnableOption "CRProxy, a generic Docker image proxy";

    package = mkPackageOption pkgs "crproxy" { };

    listenAddress = mkOption {
      default = ":8080";
      example = literalExpression ''
        ":8080"
      '';
      type = types.str;
      description = "Address and port to listen on.";
    };

    behindProxy = mkOption {
      default = false;
      example = literalExpression ''
        true
      '';
      type = types.bool;
      description = "Behind the reverse proxy such as nginx or caddy, which can receive HTTP headers from fronted nginx or caddy. Enable it when enable nginx or caddy as a reverse proxy server.";
    };

    userpass = mkOption {
      default = [ ];
      example = literalExpression ''
        [ "user1:password@docker.io" "user2:password@ghcr.io" ]
      '';
      type = types.listOf types.str;
      description = "Credentials for registries that require authentication.";
    };

    allowHostList = mkOption {
      default = [ ];
      example = literalExpression ''
        [ "192.168.233.233" "10.233.233.233" "1.1.1.1" ]
      '';
      type = types.listOf types.str;
      description = "Allow host list, specifiy which host(s) can access.";
    };

    allowImageList = mkOption {
      default = [ ];
      example = literalExpression ''
        [
          "busybox"
          "hello-world"
        ]
      '';
      type = types.listOf types.str;
      description = "Docker images to allow.";
    };

    blockMessage = mkOption {
      type = types.str;
      default = "This image is not allowed for my proxy!";
      example = literalExpression ''
        "Not allowed"
      '';
      description = "Block message for disallowed images.";
    };

    blockIPList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "IP addresses which may not access the crproxy.";
    };

    defaultRegistry = mkOption {
      type = types.str;
      default = "docker.io";
      description = "Default registry used for non full-path docker pull.";
    };

    simpleAuthUser = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''
        [ "user1:password" "user2:password" ]
      '';
      description = "Users which may access the crproxy. An empty list disables simple authentication.";
    };

    privilegedIPList = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Privileged IP list, which can access the crproxy without limits.";
    };

    extraOptions = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = literalExpression ''
        [
          "--retry=3"
          "--limit-delay"
        ]
      '';
      description = ''
        See https://github.com/DaoCloud/crproxy/blob/master/cmd/crproxy/main.go for more.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.crproxy = {
      wantedBy = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        RestartSec = 5;
        ExecStart = concatStringsSep " " concatLists [
          [
            (lib.getExe cfg.package)
            "--default-registry=${cfg.defaultRegistry}"
            "--address=${cfg.listenAddress}"
          ]
          (optionals cfg.behindProxy [ "--behind" ])
          (optionals useAllowImageList [ "--allow-image-list-from-file=${allowImageListFile}" ])
          (optionals useAllowImageList [ "--block-message=${cfg.blockMessage}" ])
          (optionals useBlockIPList [ "--block-ip-list-from-file=${blockIPListFile}" ])
          (optionals (cfg.simpleAuthUser != [ ]) [ "--simple-auth" ])
          (map (e: "--simple-auth-user=${e}") cfg.simpleAuthUser)
          (map (e: "--allow-host-list=${e}") cfg.allowHostList)
          (map (e: "--privileged-ip-list=${e}") cfg.privilegedIPList)
          (map (e: "--user=${e}") cfg.userpass)

          cfg.extraOptions
        ];
      };
    };
  };
}
