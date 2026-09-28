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

  defaultBaseq3 = pkgs.requireFile rec {
    name = "baseq3";
    hashMode = "recursive";
    sha256 = "5dd8ee09eabd45e80450f31d7a8b69b846f59738726929298d8a813ce5725ed3";
    message = ''
      Unfortunately, we cannot download ${name} automatically.
      Please purchase a legitimate copy of Quake 3 and change into the installation directory.

      You can either add all relevant files to the nix-store like this:
      mkdir /tmp/baseq3
      cp baseq3/pak*.pk3 /tmp/baseq3
      nix-store --add-fixed sha256 --recursive /tmp/baseq3

      Alternatively you can set services.quake3-server.baseq3 to a path and
      copy the baseq3 directory into the .q3a subdirectory of that path.
    '';
  };

  home = pkgs.runCommand "quake3-home" { } ''
    mkdir -p $out/.q3a/baseq3

    for file in ${cfg.baseq3}/*; do
      ln -s $file $out/.q3a/baseq3/$(basename $file)
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
        default = defaultBaseq3;
        defaultText = literalMD "Manually downloaded Quake 3 installation directory.";
        example = "/var/lib/q3ds";
        description = ''
          Path to the baseq3 files (pak*.pk3). If this is on the nix store (type = package) all .pk3 files should be saved
          in the top-level directory. If this is on another filesystem (e.g /var/lib/baseq3) the .pk3 files are searched in
          $baseq3/.q3a/baseq3/
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
          ) "+${pkgs.coreutils}/bin/cp ${configFile} ${cfg.baseq3}/.q3a/baseq3/nix.cfg";

          ExecStart = "${cfg.package}/bin/ioq3ded +exec nix.cfg";
        };
      };
    };
}
