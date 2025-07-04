{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.fediwall;
  pkg = cfg.package.override { conf = cfg.settings; };
  format = pkgs.formats.json { };
in
{
  options.services.fediwall = {
    enable = lib.mkEnableOption "fediwall, a social media wall for the fediverse";
    package = lib.mkPackageOption pkgs "fediwall" { };
    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      example = "fediwall.example.org";
      description = "The hostname to serve fediwall on.";
    };
    settings = lib.mkOption {
      default = { };
      description = ''
        Fediwall configuration. See
        https://github.com/defnull/fediwall/blob/main/public/wall-config.json.example
        for information on supported values.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          servers = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ "mastodon.social" ];
            description = "Servers to load posts from";
          };
          tags = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            example = lib.literalExpression "[ \"cats\" \"dogs\"]";
            description = "Tags to follow";
          };
          loadPublic = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Load public posts";
          };
          loadFederated = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Load federated posts";
          };
          loadTrends = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Load trending posts";
          };
          hideSensitive = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Hide sensitive (potentially NSFW) posts";
          };
          hideBots = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Hide posts from bot accounts";
          };
          hideReplies = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Hide replies";
          };
          hideBoosts = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Hide boosts";
          };
          showMedia = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Show media in posts";
          };
          playVideos = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Autoplay videos in posts";
          };
        };
      };
    };
    nginx = lib.mkOption {
      type = lib.types.submodule (
        lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) { }
      );
      default = { };
      example = lib.literalExpression ''
        {
          serverAliases = [
            "fedi.''${config.networking.domain}"
          ];
          # Enable TLS and use let's encrypt for ACME
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = "Allows customizing the nginx virtualHost settings";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.hostName}" = lib.mkMerge [
        cfg.nginx
        {
          root = lib.mkForce "${pkg}";
          locations = {
            "/" = {
              index = "index.html";
            };
          };
        }
      ];
    };
  };
}
