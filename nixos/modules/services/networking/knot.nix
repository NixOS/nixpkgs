{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.knot;

  configFile = pkgs.writeTextFile {
    name = "knot.conf";
    text = (concatMapStringsSep "\n" (file: "include: ${file}") cfg.keyFiles) + "\n" +
           cfg.extraConfig;
    checkPhase = lib.optionalString (cfg.keyFiles == []) ''
      ${cfg.package}/bin/knotc --config=$out conf-check
    '';
  };

  socketFile = "/run/knot/knot.sock";

  knot-cli-wrappers = pkgs.stdenv.mkDerivation {
    name = "knot-cli-wrappers";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${cfg.package}/bin/knotc "$out/bin/knotc" \
        --add-flags "--config=${configFile}" \
        --add-flags "--socket=${socketFile}"
      makeWrapper ${cfg.package}/bin/keymgr "$out/bin/keymgr" \
        --add-flags "--config=${configFile}"
      for executable in kdig khost kjournalprint knsec3hash knsupdate kzonecheck
      do
        ln -s "${cfg.package}/bin/$executable" "$out/bin/$executable"
      done
      mkdir -p "$out/share"
      ln -s '${cfg.package}/share/man' "$out/share/"
    '';
  };
in {
  options = {
    services.knot = {
      enable = mkEnableOption (lib.mdDoc "Knot authoritative-only DNS server");

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          List of additional command line parameters for knotd
        '';
      };

      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          A list of files containing additional configuration
          to be included using the include directive. This option
          allows to include configuration like TSIG keys without
          exposing them to the nix store readable to any process.
          Note that using this option will also disable configuration
          checks at build time.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra lines to be added verbatim to knot.conf
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.knot-dns;
        defaultText = literalExpression "pkgs.knot-dns";
        description = lib.mdDoc ''
          Which Knot DNS package to use
        '';
      };
    };
  };

  config = mkIf config.services.knot.enable {
    users.groups.knot = {};
    users.users.knot = {
      isSystemUser = true;
      group = "knot";
      description = "Knot daemon user";
    };

    systemd.services.knot = {
      unitConfig.Documentation = "man:knotd(8) man:knot.conf(5) man:knotc(8) https://www.knot-dns.cz/docs/${cfg.package.version}/html/";
      description = cfg.package.meta.description;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = ["network.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/knotd --config=${configFile} --socket=${socketFile} ${concatStringsSep " " cfg.extraArgs}";
        ExecReload = "${knot-cli-wrappers}/bin/knotc reload";
        User = "knot";
        Group = "knot";

        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
        ];
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = false; # breaks capability passing
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        Restart = "on-abort";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime =true;
        RestrictSUIDSGID = true;
        RuntimeDirectory = "knot";
        StateDirectory = "knot";
        StateDirectoryMode = "0700";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    environment.systemPackages = [ knot-cli-wrappers ];
  };
}
