{ config, lib, pkgs, ... }:

with lib;

let
    cfg = config.services.aws-xray-daemon;

    xrayConfig = {
        TotalBufferSizeMB = cfg.TotalBufferSizeMB;
        Concurrency = cfg.Concurrency;
        Region = cfg.Region;
        Endpoint = cfg.EndPoint;
        Socket = {
          UDPAddress = cfg.Socket.UDPAddress;
          TCPAddress = cfg.Socket.TCPAddress;
        };
        Logging = {
          LogRotation = cfg.Logging.LogRotation;
          LogLevel = cfg.Logging.LogLevel;
          LogPath = cfg.Logging.LogPath;
        };
        LocalMode = cfg.LocalMode;
        ResourceARN = cfg.ResourceARN;
        RoleARN = cfg.RoleARN;
        NoVerifySSL = cfg.NoVerifySSL;
        ProxyAddress = cfg.ProxyAddress;
        Version = cfg.Version;
    };

    configFile = pkgs.writeText "xray.yaml" (builtins.toJSON xrayConfig);
in
{
    options.services.aws-xray-daemon = {
        enable = mkOption {
            description = "Whether to enable aws-xray-daemon service";
            default = false;
            type = types.bool;
        };

        package = mkOption {
            description = "Which aws-xray-daemon package to use";
            default = pkgs.aws-xray-daemon;
            type = types.package;
        };

        TotalBufferSizeMB = mkOption {
            description = "Maximum buffer size in MB (minimum 3). Choose 0 to use 1% of host memory.";
            default = 0;
            type = types.int;
        };

        Concurrency = mkOption {
            description = "Maximum number of concurrent calls to AWS X-Ray to upload segment documents.";
            default = 8;
            type = types.int;
        };

        Region = mkOption {
            description = "Send segments to AWS X-Ray service in a specific region.";
            default = "";
            type = types.str;
        };

        EndPoint = mkOption {
            description = "Change the X-Ray service endpoint to which the daemon sends segment documents.";
            default = "";
            type = types.str;
        };

        Socket = {
            UDPAddress = mkOption {
                description = "Change the address and port on which the daemon listens for UDP packets containing segment documents.";
                default = "127.0.0.1:2000";
                type = types.str;
            };

            TCPAddress = mkOption {
                description = "Change the address and port on which the daemon listens for HTTP requests to proxy to AWS X-Ray.";
                default = "127.0.0.1:2000";
                type = types.str;
            };
        };

        Logging = {
            LogRotation = mkOption {
                description = "Whether to enable log rotation.";
                default = true;
                type = types.bool;
            };

            LogLevel = mkOption {
                description = "Change the log level, from most verbose to least: dev, debug, info, warn, error, prod (default).";
                default = "prod";
                type = types.str;
            };

            LogPath = mkOption {
                description = "Output logs to the specified file path.";
                default = "";
                type = types.str;
            };
        };

        LocalMode = mkOption {
            description = "Turn on local mode to skip EC2 instance metadata check.";
            default = false;
            type = types.bool;
        };

        ResourceARN = mkOption {
            description = "Amazon Resource Name (ARN) of the AWS resource running the daemon.";
            default = "";
            type = types.str;
        };

        RoleARN = mkOption {
            description = "Assume an IAM role to upload segments to a different account.";
            default = "";
            type = types.str;
        };

        NoVerifySSL = mkOption {
            description = "Disable TLS certificate verification.";
            default = false;
            type = types.bool;
        };

        ProxyAddress = mkOption {
            description = "Upload segments to AWS X-Ray through a proxy.";
            default = "";
            type = types.str;
        };

        Version = mkOption {
            description = "Daemon configuration file format version.";
            default = 2;
            type = types.int;
        };
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];

        systemd.services.aws-xray-daemon = {
            description = "aws xray daemon service";
            wantedBy = [ "multi-user.target" ];
            after = [ "networking.target" ];
            serviceConfig = {
                ExecStart = "${cfg.package.bin}/bin/daemon --config ${configFile}";
                User = "xray";
            };
        };

        users.users.xray = {
          description = "xray user";
        };
    };
}