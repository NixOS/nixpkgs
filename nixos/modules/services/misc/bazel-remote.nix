{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bazelRemote;
  condOption = name: value: if value != null then " --${name} ${toString value}" else "";
  bazelRemoteConfig
    = condOption "config_file" cfg.configFile
    + condOption "dir" cfg.dir
    + condOption "max_size" cfg.maxSize
    + condOption "host" cfg.bind
    + condOption "port" cfg.port
    + condOption "htpasswd_file" cfg.htpasswdFile
    + condOption "tls_cert_file" cfg.tlsCertFile
    + condOption "tls_key_file" cfg.tlsKeyFile
    + condOption "idle_timeout" cfg.idleTimeout
    ;
in
{

  ###### interface

  options = {

    services.bazelRemote = {

      enable = mkEnableOption "Whether to enable the Bazel Remote server.";

      package = mkOption {
        type = types.package;
        default = pkgs.bazel-remote;
        defaultText = "pkgs.bazel-remote";
        description = "Which Bazel Remote derivation to use.";
      };

      user = mkOption {
        type = types.str;
        default = "bazel";
        description = "User account under which Bazel Remote runs.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "The port for Bazel Remote to listen to.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      bind = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "The IP interface to bind to, defaults to \"127.0.0.1\".";
        example = "127.0.0.1";
      };

      configFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "Path to a YAML configuration file. If this option is specified then all other bazel-remote options are ignored";
      };

      dir = mkOption {
        type = types.path;
        description = "Directory path where to store the cache contents";
      };

      maxSize = mkOption {
        type = types.int;
        description = "The maximum size of the remote cache in GiB";
      };

      htpasswdFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "Path to a .htpasswd file. Please read <link xlink:href=\"https://httpd.apache.org/docs/2.4/programs/htpasswd.html\"/>";
      };

      tlsCertFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "Path to a pem encoded certificate file.";
      };

      tlsKeyFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "Path to a pem encoded certificate file.";
      };

      idleTimeout = mkOption {
        type = types.int;
        default = 0;
        description = "The maximum period in seconds of having received no request after which the server will shut itself down. A value of 0 disables the timeout, disabled by default.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.bazelRemote.enable {

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.bazel-remote =
      { description = "Bazel Remote Cache";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/bazel-remote ${bazelRemoteConfig}";
          DynamicUser = true;
        };
      };

  };

}
