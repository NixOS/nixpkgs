{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    literalMD
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.services.quake3-server;

  toQuake3Value = value: if lib.isBool value then (if value then "1" else "0") else toString value;

  toQuake3Config =
    settings:
    lib.concatStrings (
      lib.mapAttrsToList (name: value: ''seta ${name} "${toQuake3Value value}"'' + "\n") settings
    );

  configFile = pkgs.writeText "q3ds-extra.cfg" ''
    ${toQuake3Config cfg.settings}
    ${cfg.extraConfig}
  '';

  home = pkgs.runCommand "quake3-home" { } ''
    mkdir -p $out/.q3a/baseq3
    for file in $(find -L ${cfg.baseq3} -maxdepth 2 -name '*.pk3'); do
      ln -s "$file" "$out/.q3a/baseq3/$(basename "$file")"
    done
    ln -s ${configFile} $out/.q3a/baseq3/nix.cfg
  '';
in
{

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "quake3-server" "port" ]
      [ "services" "quake3-server" "settings" "net_port" ]
    )
  ];

  options = {
    services.quake3-server = {
      enable = mkEnableOption "Quake 3 dedicated server";
      package = lib.mkPackageOption pkgs "ioquake3" { };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the firewall.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = types.attrsOf (
            types.nullOr (
              types.oneOf [
                types.str
                types.bool
                types.int
                types.float
                types.port
              ]
            )
          );
          options = {
            net_port = lib.mkOption {
              type = lib.types.port;
              default = 27960;
              description = "UDP port for the dedicated server to bind to.";
            };
          };
        };
        default = { };
        example = {
          sv_hostname = "My Quake 3 server";
          g_gametype = 0;
          sv_pure = true;
        };
        description = ''
          Quake 3 cvars set via `seta` on server start (i.e. persisted,
          archive-flagged cvars – the vast majority of server settings).
          Note that options changed via RCON will not be persisted. To list
          all possible options, use "cvarlist 1" via RCON.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          // map rotation and other things that don't map onto plain cvars
          set d1 "map q3dm1 ; set nextmap vstr d2"
          set d2 "map q3dm7 ; set nextmap vstr d1"
          vstr d1

          // rarely needed: cvars with a non-seta flag
          sets sv_privatePassword "hidden"
        '';
        description = ''
          Extra configuration lines appended after `settings`, for anything
          that isn't a plain persisted cvar: map-rotation scripts, `exec`,
          `vstr`, aliases, or cvars that need `set`/`sets`/`sett`/`setu`
          instead of `seta`. Note that options changed via RCON will not be
          persisted. To list all possible options, use "cvarlist 1" via RCON.
        '';
      };

      baseq3 = mkOption {
        type = types.either types.package types.path;
        default = pkgs.symlinkJoin {
          name = "quake3-demo-content";
          paths = [
            pkgs.quake3demodata
            pkgs.quake3pointrelease
          ];
        };
        defaultText = "Freely redistributable Quake 3 demo data (`pak0`) plus the 1.32 point release files (`pak1`-`pak8`), merged together.";
        example = "/var/lib/q3ds";
        description = ''
          Path to the baseq3 files (pak*.pk3). If this is on the nix store (type = package) all .pk3 files should be saved
          in the top-level directory. If this is on another filesystem (e.g /var/lib/baseq3) the .pk3 files are searched in
          $baseq3/.q3a/baseq3/

          Defaults to the freely redistributable demo data (pak0) merged
          with the 1.32 point release files (pak1-pak8), so the game runs
          out of the box without owning a retail copy.
        '';
      };
    };
  };

  config =
    let
      baseq3InStore = builtins.typeOf cfg.baseq3 == "set";
    in
    mkIf cfg.enable {
      networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ cfg.settings.net_port ];

      systemd.services.q3ds = {
        description = "Quake 3 dedicated server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.HOME = if baseq3InStore then home else cfg.baseq3;

        serviceConfig = with lib; {
          Restart = "always";
          DynamicUser = true;
          WorkingDirectory = if baseq3InStore then home else cfg.baseq3;

          # It is possible to alter configuration files via RCON. To ensure reproducibility we have to prevent this
          ReadOnlyPaths = if baseq3InStore then home else cfg.baseq3;
          ExecStartPre = optionalString (
            !baseq3InStore
          ) "+${lib.getExe' pkgs.coreutils "cp"} ${configFile} ${cfg.baseq3}/.q3a/baseq3/nix.cfg";
          ExecStart = "${lib.getExe' cfg.package "ioq3ded"} +set fs_homepath ${
            if baseq3InStore then home else cfg.baseq3
          }/.q3a +exec nix.cfg";

        };
      };
    };
}
