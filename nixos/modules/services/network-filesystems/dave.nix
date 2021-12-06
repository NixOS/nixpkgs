{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dave;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.dave = {
    enable = mkEnableOption "dave WebDAV server";

    user = mkOption {
      type = types.str;
      default = "dave-webdav";
      description = ''
        User account under which dave runs.

        <note><para>
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the dave service starts.
        </para></note>
      '';
    };

    group = mkOption {
      type = types.str;
      default = "dave-webdav";
      description = ''
        Group under which dave runs.

        <note><para>
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the dave service starts.
        </para></note>
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to automatically open the specified ports in the firewall.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The bind address.";
          };
          port = mkOption {
            type = types.port;
            default = 8000;
            description = "The listening port.";
          };
          dir = mkOption {
            type = types.str;
            description = "The provided base dir.";
          };
        };
      };
      default = { };
      example = {
        address = "127.0.0.1";
        port = 8000;
        dir = "/home/webdav";
        prefix = "/webdav";
        users = {
          user = {
            password =
              "$2a$10$yITzSSNJZAdDZs8iVBQzkuZCzZ49PyjTiPIrmBUKUpB0pwX7eySvW";
            subdir = "/user";
          };
          admin = {
            password =
              "$2a$10$DaWhagZaxWnWAOXY0a55.eaYccgtMOL3lGlqI3spqIBGyM0MD.EN6";
          };
        };
      };
      description = ''
        Configuration for dave. See
        <link xlink:href="https://github.com/micromata/dave/blob/master/Readme.md"/>
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    users = {
      users = mkIf (cfg.user == "dave-webdav") {
        dave-webdav = {
          description = "dave webdav server user";
          isSystemUser = true;
          group = cfg.group;
        };
      };
      groups = mkIf (cfg.group == "dave-webdav") { dave-webdav = { }; };
    };

    systemd =
      let workDir = "/run/dave";
      in
      {
        services.dave = {
          description = "dave - The simple webdav server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.dave}/bin/dave";
            WorkingDirectory = workDir;

            User = cfg.user;
            Group = cfg.group;

            CapabilityBoundingSet = "";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            ReadWritePaths = [ cfg.settings.dir ];
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallErrorNumber = "EPERM";
            SystemCallFilter = "@system-service";
          };
        };

        tmpfiles.rules = [
          "L+ ${workDir}/config.yaml - - - - ${
          settingsFormat.generate "dave-config" cfg.settings
        }"
        ];
      };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];
  };
}

