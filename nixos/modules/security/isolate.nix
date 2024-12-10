{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    maintainers
    ;

  cfg = config.security.isolate;
  configFile = pkgs.writeText "isolate-config.cf" ''
    box_root=${cfg.boxRoot}
    lock_root=${cfg.lockRoot}
    cg_root=${cfg.cgRoot}
    first_uid=${toString cfg.firstUid}
    first_gid=${toString cfg.firstGid}
    num_boxes=${toString cfg.numBoxes}
    restricted_init=${if cfg.restrictedInit then "1" else "0"}
    ${cfg.extraConfig}
  '';
  isolate = pkgs.symlinkJoin {
    name = "isolate-wrapped-${pkgs.isolate.version}";

    paths = [ pkgs.isolate ];

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/isolate \
        --set ISOLATE_CONFIG_FILE ${configFile}

      wrapProgram $out/bin/isolate-cg-keeper \
        --set ISOLATE_CONFIG_FILE ${configFile}
    '';
  };
in
{
  options.security.isolate = {
    enable = mkEnableOption ''
      Sandbox for securely executing untrusted programs
    '';

    package = mkPackageOption pkgs "isolate-unwrapped" { };

    boxRoot = mkOption {
      type = types.path;
      default = "/var/lib/isolate/boxes";
      description = ''
        All sandboxes are created under this directory.
        To avoid symlink attacks, this directory and all its ancestors
        must be writeable only by root.
      '';
    };

    lockRoot = mkOption {
      type = types.path;
      default = "/run/isolate/locks";
      description = ''
        Directory where lock files are created.
      '';
    };

    cgRoot = mkOption {
      type = types.str;
      default = "auto:/run/isolate/cgroup";
      description = ''
        Control group which subgroups are placed under.
        Either an explicit path to a subdirectory in cgroupfs, or "auto:file" to read
        the path from "file", where it is put by `isolate-cg-helper`.
      '';
    };

    firstUid = mkOption {
      type = types.numbers.between 1000 65533;
      default = 60000;
      description = ''
        Start of block of UIDs reserved for sandboxes.
      '';
    };

    firstGid = mkOption {
      type = types.numbers.between 1000 65533;
      default = 60000;
      description = ''
        Start of block of GIDs reserved for sandboxes.
      '';
    };

    numBoxes = mkOption {
      type = types.numbers.between 1000 65533;
      default = 1000;
      description = ''
        Number of UIDs and GIDs to reserve, starting from
        {option}`firstUid` and {option}`firstGid`.
      '';
    };

    restrictedInit = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If true, only root can create sandboxes.
      '';
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        Extra configuration to append to the configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      isolate
    ];

    systemd.services.isolate = {
      description = "Isolate control group hierarchy daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${isolate}/bin/isolate-cg-keeper";
        Slice = "isolate.slice";
        Delegate = true;
      };
    };

    systemd.slices.isolate = {
      description = "Isolate sandbox slice";
    };

    meta.maintainers = with maintainers; [ virchau13 ];
  };
}
