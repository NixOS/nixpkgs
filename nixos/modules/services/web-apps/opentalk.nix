{
  options,
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    types
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    mkDefault
    ;

  opt = options.services.opentalk;
  cfg = config.services.opentalk;
  configFormat = pkgs.formats.toml { };
  frontendConfigFormat = pkgs.formats.json { };
in
{
  options.services.opentalk = {
    enable = mkEnableOption "OpenTalk";

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to set up an nginx virtual host.
        '';
      };

      frontendDomain = mkOption {
        type = types.nonEmptyStr;
        example = "opentalk.example.com";
        description = ''
          The domain name under which to set up the frontend virtual host.
        '';
      };

      controllerDomain = mkOption {
        type = types.nonEmptyStr;
        example = "controller.opentalk.example.com";
        description = ''
          The domain name under which to set up the frontend virtual host.
        '';
      };
    };

    oidc = {
      authority = mkOption {
        type = types.nonEmptyStr;
        example = "https://example.com/auth/realms/OPENTALK";
        description = ''
          Base url for the OIDC authority. Will be used for frontend and controller unless overwritten by
          `oidc.frontend.authority` or `oidc.controller.authority`.

          Currently only Keycloak is supported. Full compliance with other OIDC providers is not guaranteed.
        '';
      };
      frontend = {
        authority = mkOption {
          type = types.nonEmptyStr;
          default = cfg.oidc.authority;
          defaultText = lib.literalExpression "config.${opt.oidc.authority}";
          description = ''
            OIDC authority base url for the frontend.
            Optional, if not set, the value from `oidc.authority` is used.
            Will be made available to the frontend via the `GET /v1/auth/login` endpoint.
          '';
        };
        clientId = mkOption {
          type = types.nonEmptyStr;
          default = "Frontend";
          description = ''
            Client id that will be used by the frontend when connecting to the oidc provider.
          '';
        };
      };
      controller = {
        authority = mkOption {
          type = types.nonEmptyStr;
          default = cfg.oidc.authority;
          defaultText = lib.literalExpression "config.${opt.oidc.authority}";
          description = ''
            OIDC authority base url for the controller.
            Optional, if not set, the value from `oidc.authority` is used.
          '';
        };
        clientId = mkOption {
          type = types.nonEmptyStr;
          default = "Controller";
          description = ''
            Client id that will be used by the controller when connecting to the oidc provider.
          '';
        };
        clientSecretFile = mkOption {
          type = types.path;
          description = ''
            Client secret that will be used by the controller when connecting to the oidc provider.
          '';
        };
      };
    };

    controller = {
      package = mkPackageOption pkgs "opentalk-controller" { };
      config = mkOption {
        type = types.submodule {
          freeformType = configFormat.type;
          options = {
            http = {
              addr = mkOption {
                type = types.nonEmptyStr;
                default = "localhost";
                description = ''
                  An optional address to which to bind.
                  Can be either a hostname, or an IP address.
                '';
              };
              port = mkOption {
                type = types.port;
                default = 11311;
                description = ''
                  The port to bind the HTTP Server to.
                '';
              };
            };
          };
        };
        default = { };
        description = ''
          Controller configuration as a Nix attribute set. All settings can also be passed
          from the environment.

          See <https://docs.opentalk.eu/admin/controller/core/configuration/> for possible options.
        '';
      };
    };

    frontend = {
      package = mkPackageOption pkgs "opentalk-web-frontend" { };
      config = mkOption {
        type = types.submodule {
          freeformType = frontendConfigFormat.type;
          options = {
            baseUrl = mkOption {
              type = types.nonEmptyStr;
              default = "https://${cfg.nginx.frontendDomain}";
              defaultText = lib.literalExpression ''
                config.''\${opt.nginx.frontendDomain}
              '';
              description = "Base URL of the frontend";
            };
            controller = mkOption {
              type = types.nonEmptyStr;
              default = cfg.nginx.controllerDomain;
              defaultText = lib.literalExpression "config.${opt.nginx.controllerDomain}";
              description = ''
                The hostname and port under which the controller is reachable, do not include http here.
              '';
            };
            insecure = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether the connections to the controller should be tls encrypted (http(s), ws(s)) WARNING! This is needed when connecting to a controller hosted on localhost without a TLS cert
              '';
            };
            errorReportAddress = mkOption {
              type = types.nonEmptyStr;
              example = "reports@example.com";
              description = ''
                An email address, where the error reports should be send
              '';
            };
            libravatarDefaultImage = mkOption {
              type = types.enum [
                "404"
                "mm"
                "monsterid"
                "wavatar"
                "retro"
                "robohash"
                "pagan"
              ];
              default = "robohash";
              description = "Default image for the avatar";
            };
            speedTest.ndtServer = mkOption {
              type = types.nullOr types.str;
              description = ''
                The speed test will use this target server if not empty.
                If missing, an automatic public server discovery will start.
              '';
            };
            features = {
              userSearch = mkOption {
                type = types.bool;
                default = true;
                description = "Enable dashboard feature of geting list of user for inviting them to the event";
              };
              muteUsers = mkOption {
                type = types.bool;
                default = true;
                description = "Enable moderator option to mute user / users";
              };
              resetHandraises = mkOption {
                type = types.bool;
                default = true;
                description = "Enable moderator option to reset users' raised hands";
              };
              addUser = mkOption {
                type = types.bool;
                default = false;
                description = "Under construction";
              };
              joinWithoutMedia = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  If is set to true, it will prevent user to join conference with audio/video on
                '';
              };
              sharedFolder = mkOption {
                type = types.bool;
                default = false;
                description = "Activates shared folders";
              };
              e2eEncryption = mkOption {
                type = types.bool;
                default = false;
                description = "Enable e2e encryption option when creating a meeting";
              };
            };
            videoBackgrounds = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    altText = mkOption {
                      type = types.nonEmptyStr;
                      description = "Textual description of the background image";
                    };
                    url = mkOption {
                      type = types.nonEmptyStr;
                      description = "URL to a background image with a resolution of 1280x720";
                    };
                    thumb = mkOption {
                      type = types.nonEmptyStr;
                      description = "URL to a thumbnail image with a resolution of 128x72";
                    };
                  };
                }
              );
              description = "A list of video backgrounds";
              default = [
                {
                  altText = "Elevate";
                  url = "/assets/videoBackgrounds/elevate-bg.png";
                  thumb = "/assets/videoBackgrounds/thumbs/elevate-bg-thumb.png";
                }
                {
                  altText = "Living room";
                  url = "/assets/videoBackgrounds/ot1.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot1-thumb.png";
                }
                {
                  altText = "Conference room";
                  url = "/assets/videoBackgrounds/ot2.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot2-thumb.png";
                }
                {
                  altText = "Beach at sunset";
                  url = "/assets/videoBackgrounds/ot3.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot3-thumb.png";
                }
                {
                  altText = "Boat on shore";
                  url = "/assets/videoBackgrounds/ot4.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot4-thumb.png";
                }
                {
                  altText = "Pink living room";
                  url = "/assets/videoBackgrounds/ot5.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot5-thumb.png";
                }
                {
                  altText = "Bookshelf";
                  url = "/assets/videoBackgrounds/ot6.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot6-thumb.png";
                }
                {
                  altText = "Bookshelves surround an open door";
                  url = "/assets/videoBackgrounds/ot7.png";
                  thumb = "/assets/videoBackgrounds/thumbs/ot7-thumb.png";
                }
              ];
            };
            maxVideoBandwidth = mkOption {
              type = types.ints.positive;
              default = 600000;
              description = "The maximum video bandwidth";
            };
            settings.waitingRoomDefaultValue = mkOption {
              type = types.bool;
              default = true;
              description = "To enable waiting room switch by default";
            };
          };
        };
        default = { };
        description = ''
          Frontend configuration as a Nix attribute set.
          Warning: all values are publicly exposed to the web.

          See <https://gitlab.opencode.de/opentalk/web-frontend> for possible options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.opentalk = {
      controller.config = mkDefault {
        oidc = {
          inherit (cfg.oidc) authority;
          frontend = {
            inherit (cfg.oidc.frontend) authority;
            client_id = cfg.oidc.frontend.clientId;
          };
          controller = {
            inherit (cfg.oidc.controller) authority;
            client_id = cfg.oidc.controller.clientId;
          };
        };
      };
      frontend.config = mkDefault {
        version = {
          product = "25.1.3";
          frontend = cfg.frontend.package.version;
        };
        provider.active = false;
        beta.isBeta = false;
        changePassword.active = false;
        disallowCustomDisplayName = false;
        oidcConfig = {
          inherit (cfg.oidc.frontend) authority clientId;
          scope = "openid profile email";
          redirectPath = "/auth/callback";
          signOutRedirectUri = "/dashboard";
          popupRedirectPath = "/auth/popup_callback";
        };
        speedTest = {
          ndtDownloadWorkerJs = "/workers/ndt7-download-worker.js";
          ndtUploadWorkerJs = "/workers/ndt7-upload-worker.js";
        };
      };
    };
  };
}
