{ config, lib, pkgs, ...}:

with lib;

let
  cfgs = config.services.cgit;

  settingType = with types; oneOf [ bool int str ];

  genAttrs' = names: f: listToAttrs (map f names);

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

  stripLocation = cfg: removeSuffix "/" cfg.nginx.location;

  regexLocation = cfg: regexEscape (stripLocation cfg);

  mkFastcgiPass = cfg: ''
    ${if cfg.nginx.location == "/" then ''
      fastcgi_param PATH_INFO $uri;
    '' else ''
      fastcgi_split_path_info ^(${regexLocation cfg})(/.+)$;
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

  mkCgitrc = cfg: pkgs.writeText "cgitrc" ''
    # global settings
    ${concatStringsSep "\n" (
        mapAttrsToList
          cgitrcLine
          ({ virtual-root = cfg.nginx.location; } // cfg.settings)
      )
    }
    ${optionalString (cfg.scanPath != null) (cgitrcLine "scan-path" cfg.scanPath)}

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
          cfg.repos
      )
    }

    # extra config
    ${cfg.extraConfig}
  '';

  mkCgitReposDir = cfg:
    if cfg.scanPath != null then
      cfg.scanPath
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
              cfg.repos
          )
        }
      '';

in
{
  options = {
    services.cgit = mkOption {
      description = "Configure cgit instances.";
      default = {};
      type = types.attrsOf (types.submodule ({ config, ... }: {
        options = {
          enable = mkEnableOption "cgit";

          package = mkPackageOption pkgs "cgit" {};

          nginx.virtualHost = mkOption {
            description = "VirtualHost to serve cgit on, defaults to the attribute name.";
            type = types.str;
            default = config._module.args.name;
            example = "git.example.com";
          };

          nginx.location = mkOption {
            description = "Location to serve cgit under.";
            type = types.str;
            default = "/";
            example = "/git/";
          };

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
        };
      }));
    };
  };

  config = mkIf (any (cfg: cfg.enable) (attrValues cfgs)) {
    assertions = mapAttrsToList (vhost: cfg: {
      assertion = !cfg.enable || (cfg.scanPath == null) != (cfg.repos == {});
      message = "Exactly one of services.cgit.${vhost}.scanPath or services.cgit.${vhost}.repos must be set.";
    }) cfgs;

    services.fcgiwrap.enable = true;

    services.nginx.enable = true;

    services.nginx.virtualHosts = mkMerge (mapAttrsToList (_: cfg: {
      ${cfg.nginx.virtualHost} = {
        locations = (
          genAttrs'
            [ "cgit.css" "cgit.png" "favicon.ico" "robots.txt" ]
            (name: nameValuePair "= ${stripLocation cfg}/${name}" {
              extraConfig = ''
                alias ${cfg.package}/cgit/${name};
              '';
            })
        ) // {
          "~ ${regexLocation cfg}/.+/(info/refs|git-upload-pack)" = {
            fastcgiParams = rec {
              SCRIPT_FILENAME = "${pkgs.git}/libexec/git-core/git-http-backend";
              GIT_HTTP_EXPORT_ALL = "1";
              GIT_PROJECT_ROOT = mkCgitReposDir cfg;
              HOME = GIT_PROJECT_ROOT;
            };
            extraConfig = mkFastcgiPass cfg;
          };
          "${stripLocation cfg}/" = {
            fastcgiParams = {
              SCRIPT_FILENAME = "${cfg.package}/cgit/cgit.cgi";
              QUERY_STRING = "$args";
              HTTP_HOST = "$server_name";
              CGIT_CONFIG = mkCgitrc cfg;
            };
            extraConfig = mkFastcgiPass cfg;
          };
        };
      };
    }) cfgs);
  };
}
