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
    buildInputs = [ pkgs.makeWrapper ];
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
      enable = mkEnableOption "Knot authoritative-only DNS server";

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of additional command line paramters for knotd
        '';
      };

      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
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
        description = ''
          Extra lines to be added verbatim to knot.conf
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.knot-dns;
        defaultText = "pkgs.knot-dns";
        description = ''
          Which Knot DNS package to use
        '';
      };
    };
  };

  config = mkIf config.services.knot.enable {
    users.users.knot = {
      isSystemUser = true;
      group = "knot";
      description = "Knot daemon user";
    };

    users.groups.knot.gid = null;
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
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETPCAP";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_SETPCAP";
        NoNewPrivileges = true;
        User = "knot";
        RuntimeDirectory = "knot";
        StateDirectory = "knot";
        StateDirectoryMode = "0700";
        PrivateDevices = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        SystemCallArchitectures = "native";
        Restart = "on-abort";
      };
    };

    environment.systemPackages = [ knot-cli-wrappers ];
  };
}
