{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.concourse-worker;
in
{
  options = {
    services.concourse-worker = {
      enable = mkOption {
        type = types.bool;
        default = false;

        description = ''
          Whether to enable the Concourse continuous integration worker.
        '';
      };

      name = mkOption {
        default = null;
        example = "localhost";
        type = with types; nullOr str;
        description = ''
          The name to set for the worker during registration.
          If not specified, the hostname will be used.
        '';
      };

      team = mkOption {
        default = null;
        example = "team";
        type = with types; nullOr str;
        description = ''
          The name of the team that this worker will be assigned to.
        '';
      };

      bind-ip = mkOption {
        default = "127.0.0.1";
        example = "localhost";
        type = types.str;
        description = ''
          Specifies the bind address on which the Concourse web interface listens.
          Defaults to the wildcard IPv4 address.
        '';
      };

      bind-port = mkOption {
        default = 7777;
        type = types.int;
        description = ''
          Specifies the bind port on which the Concourse web interface listens.
        '';
      };

      asset-dir = mkOption {
        default = "/tmp/garden-asset";
        type = types.str;
        description = ''
          Specifies the location where garden extracts its binary assets.
        '';
      };

      work-dir = mkOption {
        type = types.str;
        default = "/var/run/concourse";
        example = "/var/run/concourse";
        description = ''
          Directory in which to place container data.
        '';
      };

      tsa-host = mkOption {
        type = types.str;
        default = "127.0.0.1:2222";
        description = ''
          TSA host to forward the worker through. Can be specified multiple times.
          Defaults to "127.0.0.1:2222".
        '';
      };

      tsa-public-key = mkOption {
        type = types.str;
        description = ''
          File containing a public key to expect from the TSA.
        '';
      };

      tsa-worker-private-key = mkOption {
        type = types.str;
        description = ''
          File containing the private key to use when authenticating to the TSA.
        '';
      };

      baggageclaim-bind-ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Specifies the IP address on which the Baggageclaim listens.
        '';
      };

      baggageclaim-bind-port = mkOption {
        type = types.int;
        default = 7788;
        description = ''
          Specifies the port on which the Baggageclaim listens.
        '';
      };

      extraArgs = mkOption {
        default = {};
        type = with types; attrsOf (either (listOf str) str);
        example = ''
          {
            tsa-host = "127.0.0.1";
            tsa-port = "2222";
          }
        '';
        description = ''
          Specifies the extra arguments supplied to `concourse web` invocation.
          This will be transformed into `systemd` arguments.
        '';
      };

      extraFlags = mkOption {
        default = [];
        type = with types; listOf str;
        example = [ "garden-dns-proxy-enable" ];
        description = ''
          Specifies the extra flags supplied to `concourse worker` invocation.
          These flags are command line arguments that does not supply any value and acts like switches.
        '';
      };

      environment = mkOption {
        default = {};
        type = with types; attrsOf str;
        example = ''
          {
            CONCOURSE_TSA_BIND_IP = "0.0.0.0";
            CONCOURSE_TSA_BIND_PORT = "2222";
          }
        '';
        description = ''
          Specifies the extra environment variables supplied to `concourse web` invocation.
        '';
      };
    };
  };

  #### implementation
  config =
  let
    garden-runc = pkgs.garden-runc.override {
      extractDir = cfg.asset-dir;
    };

    tryEvalListArg = name: value:
      if isList value then
        concatMap (value: [ "--${name}" value ]) value
      else
        [ "--${name}" value ];

    extraFlags =
      map (flag: "--${flag}") cfg.extraFlags;

    extraArgs =
      concatMap
        (x: x)
        (mapAttrsToList tryEvalListArg cfg.extraArgs);

    maybeArgs =
      concatMap
        (arg: optionals (!isNull cfg.${arg}) [ "--${arg}" cfg.${arg} ])
        [
          "name"
          "team"
        ];

    regularArgs =
      concatMap
        (arg: [ "--${arg}" cfg.${arg} ])
        [
          "baggageclaim-bind-ip"
          "baggageclaim-bind-port"
          "bind-ip"
          "bind-port"
          "tsa-host"
          "tsa-public-key"
          "tsa-worker-private-key"
          "work-dir"
        ]
      ++ [
        "--garden-bin" "${garden-runc}/bin/gdn"
        "--resource-types" "${pkgs.concourse.resourceDir}"
      ];

    args = concatStringsSep " " (map escapeShellArgs [regularArgs extraArgs extraFlags]);
  in
    mkIf cfg.enable {
      systemd.services.concourse-worker = {
        description = "Concourse CI Worker";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = config.environment.sessionVariables // cfg.environment;
        path = with pkgs; [
          bash
          findutils
          gnugrep
          gnused
          gnutar
          gzip
          iproute
          iptables
          kmod
          utillinux
        ];

        serviceConfig.ExecStart = "${pkgs.concourse}/bin/concourse worker ${builtins.replaceStrings [ "'" ] [ "\"" ] args}";
      };
    };
}
