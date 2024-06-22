{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.cgit;

  settingType = with types; oneOf [ bool int str ];

  regexEscape =
    let
      # taken from https://github.com/python/cpython/blob/05cb728d68a278d11466f9a6c8258d914135c96c/Lib/re.py#L251-L266
      special = [
        "(" ")" "[" "]" "{" "}" "?" "*" "+" "-" "|" "^" "$" "\\" "." "&" "~"
        "#" " " "\t" "\n" "\r"
        "" # \v / 0x0B
        "" # \f / 0x0C
      ];
    in
      replaceStrings special (map (c: "\\${c}") special);

  stripLocation = removeSuffix "/";

  regexLocation = loc: regexEscape (stripLocation loc);

  mkFastcgiPass = loc: ''
    ${if loc == "/" then ''
      fastcgi_param PATH_INFO $uri;
    '' else ''
      fastcgi_split_path_info ^(${regexLocation loc})(/.+)$;
      fastcgi_param PATH_INFO $fastcgi_path_info;
    ''
    }fastcgi_pass unix:${config.services.fcgiwrap.socketAddress};
  '';

  cgitrcLine = name: value: "${name}=${
    if value == true then
      "1"
    else if value == false then
      "0"
    else
      toString value
  }";

  mkCgitrc = loc: locCfg: pkgs.writeText "cgitrc" ''
    # global settings
    ${concatStringsSep "\n" (
        mapAttrsToList
          cgitrcLine
          ({ virtual-root = loc; } // locCfg.settings)
      )
    }
    ${optionalString (locCfg.scanPath != null) (cgitrcLine "scan-path" locCfg.scanPath)}

    # repository settings
    ${concatStrings (
        mapAttrsToList
          (url: settings: ''
            ${cgitrcLine "repo.url" url}
            ${concatStringsSep "\n" (
                mapAttrsToList (name: cgitrcLine "repo.${name}") settings
              )
            }
          '')
          locCfg.repos
      )
    }

    # extra config
    ${locCfg.extraConfig}
  '';

  mkCgitReposDir = locCfg:
    if locCfg.scanPath != null then
      locCfg.scanPath
    else
      pkgs.runCommand "cgit-repos" {
        preferLocalBuild = true;
        allowSubstitutes = false;
      } ''
        mkdir -p "$out"
        ${
          concatStrings (
            mapAttrsToList
              (name: value: ''
                ln -s ${escapeShellArg value.path} "$out"/${escapeShellArg name}
              '')
              locCfg.repos
          )
        }
      '';

  vhostOptions = {
    options = {
      package = mkPackageOption pkgs "cgit" {};

      locations = mkOption {
        description = "TODO";
        type = with types; attrsOf (submodule locationOptions);
        default = { };
        example = literalExpression ''
          {
            "/git/" = {
              scanPath = "/var/lib/git";
            };
          }
        '';
      };
    };
  };

  locationOptions = {
    options = {
      repos = mkOption {
        description = "cgit repository settings, see cgitrc(5)";
        type = with types; attrsOf (attrsOf settingType);
        default = {};
        example = {
          blah = {
            path = "/var/lib/git/example";
            desc = "An example repository";
          };
        };
      };

      scanPath = mkOption {
        description = "A path which will be scanned for repositories.";
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/git";
      };

      settings = mkOption {
        description = "cgit configuration, see cgitrc(5)";
        type = types.attrsOf settingType;
        default = {};
        example = literalExpression ''
          {
            enable-follow-links = true;
            source-filter = "''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
          }
        '';
      };

      extraConfig = mkOption {
        description = "These lines go to the end of cgitrc verbatim.";
        type = types.lines;
        default = "";
      };

      locationConfig = mkOption {
        description = "Additional declarative location config for nginx";
        type = types.submodule (import ../web-servers/nginx/location-options.nix { inherit lib config; });
        default = { };
        example = literalExpression ''
          {
            basicAuth = {
              user = "password";
            };
          }
        '';
      };
    };
  };

in
{
  options = {
    services.cgit = {
      enable = mkEnableOption "cgit";

      package = mkPackageOptionMD pkgs "cgit" {};

      virtualHosts = mkOption {
        description = "TODO";
        type = with types; attrsOf (submodule vhostOptions);
        default = { };
        example = literalExpression ''
          {
            "localhost" = {
              locations."/git" = {
                scanPath = "/var/lib/git";
              };
            };
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = concatLists (
      mapAttrsToList (vhost: vhostCfg:
        mapAttrsToList (loc: locCfg: {
          assertion = (locCfg.scanPath == null) != (locCfg.repos == {});
          message = ''
            Exactly one of services.cgit.virtualHosts.${vhost}.locations.${loc}.scanPath
            or services.cgit.virtualHosts.${vhost}.locations.${loc}.repos must be set.
          '';
        }) vhostCfg.locations
      ) cfg.virtualHosts
    );

    services.fcgiwrap.enable = true;

    services.nginx = {
      enable = true;
      virtualHosts = mapAttrs (_: vhostCfg: {
        locations = mkMerge (
          optionals (vhostCfg.locations != { }) (
            map (name: {
              "= /${name}".extraConfig = ''
                alias ${vhostCfg.package}/cgit/${name};
                auth_basic off;
              '';
            }) [ "cgit.css" "cgit.png" "favicon.ico" "robots.txt" ]
          ) ++ (
            mapAttrsToList (loc: locCfg: {
              "~ ${regexLocation loc}/.+/(info/refs|git-upload-pack)" = mkMerge [
                locCfg.locationConfig
                {
                  fastcgiParams = rec {
                    SCRIPT_FILENAME = "${pkgs.git}/libexec/git-core/git-http-backend";
                    GIT_HTTP_EXPORT_ALL = "1";
                    GIT_PROJECT_ROOT = mkCgitReposDir locCfg;
                    HOME = GIT_PROJECT_ROOT;
                  };
                  extraConfig = mkFastcgiPass loc;
                }
              ];
              "${stripLocation loc}/" = mkMerge [
                locCfg.locationConfig
                {
                  fastcgiParams = {
                    SCRIPT_FILENAME = "${cfg.package}/cgit/cgit.cgi";
                    QUERY_STRING = "$args";
                    HTTP_HOST = "$server_name";
                    CGIT_CONFIG = mkCgitrc loc locCfg;
                  };
                  extraConfig = mkFastcgiPass loc;
                }
              ];
            }) vhostCfg.locations
          )
        );
      }) cfg.virtualHosts;
    };
  };
}
