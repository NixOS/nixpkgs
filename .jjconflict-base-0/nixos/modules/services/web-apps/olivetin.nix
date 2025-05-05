{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.olivetin;

  settingsFormat = pkgs.formats.yaml { };
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.olivetin = {
    enable = lib.mkEnableOption "OliveTin";

    package = lib.mkPackageOption pkgs "olivetin" { };

    user = lib.mkOption {
      type = lib.types.str;
      description = "The user account under which OliveTin runs.";
      default = "olivetin";
    };

    group = lib.mkOption {
      type = lib.types.str;
      description = "The group under which OliveTin runs.";
      default = "olivetin";
    };

    path = lib.mkOption {
      type =
        with lib.types;
        listOf (oneOf [
          package
          str
        ]);
      description = ''
        Packages added to the service's {env}`PATH`.
      '';
      defaultText = lib.literalExpression ''
        with pkgs; [ bash ]
      '';
    };

    settings = lib.mkOption {
      description = ''
        Configuration of OliveTin. See <https://docs.olivetin.app/config.html> for more information.
      '';
      default = { };

      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          ListenAddressSingleHTTPFrontend = lib.mkOption {
            type = lib.types.str;
            description = ''
              The address to listen on for the internal "microproxy" frontend.
            '';
            default = "127.0.0.1:8000";
            example = "0.0.0.0:8000";
          };
        };
      };
    };

    extraConfigFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/olivetin.yaml" ];
      description = ''
        Config files to merge into the settings defined in [](#opt-services.olivetin.settings).
        This is useful to avoid putting secrets into the nix store.
        See <https://docs.olivetin.app/config.html> for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.olivetin = {
      path = with pkgs; [ bash ];
    };

    systemd.services.olivetin = {
      description = "OliveTin";

      wantedBy = [ "multi-user.target" ];

      wants = [
        "network-online.target"
        "local-fs.target"
      ];
      after = [
        "network-online.target"
        "local-fs.target"
      ];

      inherit (cfg) path;

      preStart = ''
        tmp="$(mktemp -d)"
        trap 'rm -rf "$tmp"' EXIT
        cd "$tmp"

        cp ${settingsFormat.generate "olivetin-config.yaml" cfg.settings} config.yaml
        chmod +w config.yaml
        for ((i=0; i < ${toString (lib.length cfg.extraConfigFiles)}; i++)); do
          ${lib.getExe pkgs.yq} -yi '
            def merge($y):
              . as $x |
              if ($x | type == "object") and ($y | type == "object") then
                $x + $y + with_entries(select(.key | in($y)) | .key as $key | .value |= merge($y[$key]))
              elif ($x | type == "array") and ($y | type == "array") then
                $x + $y
              else
                $y
              end;
            merge($f | fromjson)
          ' config.yaml --rawfile f <(${lib.getExe pkgs.yq} -c . "$CREDENTIALS_DIRECTORY/config-$i.yaml")
        done
        chmod -w config.yaml

        mkdir -p /run/olivetin/config
        mv config.yaml /run/olivetin/config/config.yaml
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "olivetin";
        Restart = "always";

        LoadCredential = lib.imap0 (i: path: "config-${toString i}.yaml:${path}") cfg.extraConfigFiles;

        ExecStart = "${lib.getExe cfg.package} -configdir /run/olivetin/config";
      };
    };

    users.users = lib.mkIf (cfg.user == "olivetin") {
      olivetin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "olivetin") { olivetin = { }; };
  };
}
