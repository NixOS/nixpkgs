{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pinnwand;

  format = pkgs.formats.toml {};
  configFile = format.generate "pinnwand.toml" cfg.settings;
in
{
  options.services.pinnwand = {
    enable = mkEnableOption (lib.mdDoc "Pinnwand");

    port = mkOption {
      type = types.port;
      description = lib.mdDoc "The port to listen on.";
      default = 8000;
    };

    settings = mkOption {
      type = format.type;
      description = lib.mdDoc ''
        Your {file}`pinnwand.toml` as a Nix attribute set. Look up
        possible options in the [pinnwand.toml-example](https://github.com/supakeen/pinnwand/blob/master/pinnwand.toml-example).
      '';
      default = {};
    };
  };

  config = mkIf cfg.enable {
    services.pinnwand.settings = {
      database_uri = mkDefault "sqlite:////var/lib/pinnwand/pinnwand.db";
      paste_size = mkDefault 262144;
      paste_help = mkDefault ''
        <p>Welcome to pinnwand, this site is a pastebin. It allows you to share code with others. If you write code in the text area below and press the paste button you will be given a link you can share with others so they can view your code as well.</p><p>People with the link can view your pasted code, only you can remove your paste and it expires automatically. Note that anyone could guess the URI to your paste so don't rely on it being private.</p>
      '';
      footer = mkDefault ''
        View <a href="//github.com/supakeen/pinnwand" target="_BLANK">source code</a>, the <a href="/removal">removal</a> or <a href="/expiry">expiry</a> stories, or read the <a href="/about">about</a> page.
      '';
    };

    systemd.services = let
      hardeningOptions = {
        User = "pinnwand";
        DynamicUser = true;

        StateDirectory = "pinnwand";
        StateDirectoryMode = "0700";

        AmbientCapabilities = [];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };

      command = "${pkgs.pinnwand}/bin/pinnwand --configuration-path ${configFile}";
    in {
      pinnwand = {
        description = "Pinnwannd HTTP Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.Documentation = "https://pinnwand.readthedocs.io/en/latest/";

        serviceConfig = {
          ExecStart = "${command} http --port ${toString(cfg.port)}";
        } // hardeningOptions;
      };

      pinnwand-reaper = {
        description = "Pinnwand Reaper";
        startAt = "daily";

        serviceConfig = {
          ExecStart = "${command} -vvvv reap";  # verbosity increased to show number of deleted pastes
        } // hardeningOptions;
      };
    };
  };
}
