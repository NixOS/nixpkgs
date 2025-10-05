{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgs = config.services.cgit;

  settingType =
    with lib.types;
    oneOf [
      bool
      int
      str
    ];
  repeatedSettingType =
    with lib.types;
    oneOf [
      settingType
      (listOf settingType)
    ];

  genAttrs' = names: f: lib.listToAttrs (map f names);

  regexEscape =
    let
      # taken from https://github.com/python/cpython/blob/05cb728d68a278d11466f9a6c8258d914135c96c/Lib/re.py#L251-L266
      special = [
        "("
        ")"
        "["
        "]"
        "{"
        "}"
        "?"
        "*"
        "+"
        "-"
        "|"
        "^"
        "$"
        "\\"
        "."
        "&"
        "~"
        "#"
        " "
        "\t"
        "\n"
        "\r"
        "" # \v / 0x0B
        "" # \f / 0x0C
      ];
    in
    lib.replaceStrings special (map (c: "\\${c}") special);

  stripLocation = cfg: lib.removeSuffix "/" cfg.nginx.location;

  regexLocation = cfg: regexEscape (stripLocation cfg);

  mkFastcgiPass = name: cfg: ''
    ${
      if cfg.nginx.location == "/" then
        ''
          fastcgi_param PATH_INFO $uri;
        ''
      else
        ''
          fastcgi_split_path_info ^(${regexLocation cfg})(/.+)$;
          fastcgi_param PATH_INFO $fastcgi_path_info;
        ''
    }fastcgi_pass unix:${config.services.fcgiwrap.instances."cgit-${name}".socket.address};
  '';

  cgitrcLine =
    name: value:
    "${name}=${
      if value == true then
        "1"
      else if value == false then
        "0"
      else
        toString value
    }";

  # list value as multiple lines (for "readme" for example)
  cgitrcEntry =
    name: value: if lib.isList value then map (cgitrcLine name) value else [ (cgitrcLine name value) ];

  mkCgitrc =
    cfg:
    pkgs.writeText "cgitrc" ''
      # global settings
      ${lib.concatStringsSep "\n" (
        lib.flatten (
          lib.mapAttrsToList cgitrcEntry ({ virtual-root = cfg.nginx.location; } // cfg.settings)
        )
      )}
      ${lib.optionalString (cfg.scanPath != null) (cgitrcLine "scan-path" cfg.scanPath)}

      # repository settings
      ${lib.concatStrings (
        lib.mapAttrsToList (url: settings: ''
          ${cgitrcLine "repo.url" url}
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: cgitrcLine "repo.${name}") settings)}
        '') cfg.repos
      )}

      # extra config
      ${cfg.extraConfig}
    '';

  fcgiwrapUnitName = name: "fcgiwrap-cgit-${name}";
  fcgiwrapRuntimeDir = name: "/run/${fcgiwrapUnitName name}";
  gitProjectRoot =
    name: cfg: if cfg.scanPath != null then cfg.scanPath else "${fcgiwrapRuntimeDir name}/repos";

in
{
  options = {
    services.cgit = lib.mkOption {
      description = "Configure cgit instances.";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              enable = lib.mkEnableOption "cgit";

              package = lib.mkPackageOption pkgs "cgit" { };

              nginx.virtualHost = lib.mkOption {
                description = "VirtualHost to serve cgit on, defaults to the attribute name.";
                type = lib.types.str;
                default = config._module.args.name;
                example = "git.example.com";
              };

              nginx.location = lib.mkOption {
                description = "Location to serve cgit under.";
                type = lib.types.str;
                default = "/";
                example = "/git/";
              };

              repos = lib.mkOption {
                description = "cgit repository settings, see {manpage}`cgitrc(5)`";
                type = with lib.types; attrsOf (attrsOf settingType);
                default = { };
                example = {
                  blah = {
                    path = "/var/lib/git/example";
                    desc = "An example repository";
                  };
                };
              };

              scanPath = lib.mkOption {
                description = "A path which will be scanned for repositories.";
                type = lib.types.nullOr lib.types.path;
                default = null;
                example = "/var/lib/git";
              };

              settings = lib.mkOption {
                description = "cgit configuration, see {manpage}`cgitrc(5)`";
                type = lib.types.attrsOf repeatedSettingType;
                default = { };
                example = lib.literalExpression ''
                  {
                    enable-follow-links = true;
                    source-filter = "''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
                  }
                '';
              };

              extraConfig = lib.mkOption {
                description = "These lines go to the end of cgitrc verbatim.";
                type = lib.types.lines;
                default = "";
              };

              user = lib.mkOption {
                description = "User to run the cgit service as.";
                type = lib.types.str;
                default = "cgit";
              };

              group = lib.mkOption {
                description = "Group to run the cgit service as.";
                type = lib.types.str;
                default = "cgit";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf (lib.any (cfg: cfg.enable) (lib.attrValues cfgs)) {
    assertions = lib.mapAttrsToList (vhost: cfg: {
      assertion = !cfg.enable || (cfg.scanPath == null) != (cfg.repos == { });
      message = "Exactly one of services.cgit.${vhost}.scanPath or services.cgit.${vhost}.repos must be set.";
    }) cfgs;

    users = lib.mkMerge (
      lib.flip lib.mapAttrsToList cfgs (
        _: cfg: {
          users.${cfg.user} = {
            isSystemUser = true;
            inherit (cfg) group;
          };
          groups.${cfg.group} = { };
        }
      )
    );

    services.fcgiwrap.instances = lib.flip lib.mapAttrs' cfgs (
      name: cfg:
      lib.nameValuePair "cgit-${name}" {
        process = { inherit (cfg) user group; };
        socket = { inherit (config.services.nginx) user group; };
      }
    );

    systemd.services = lib.flip lib.mapAttrs' cfgs (
      name: cfg:
      lib.nameValuePair (fcgiwrapUnitName name) (
        lib.mkIf (cfg.repos != { }) {
          serviceConfig.RuntimeDirectory = fcgiwrapUnitName name;
          preStart = ''
            GIT_PROJECT_ROOT=${lib.escapeShellArg (gitProjectRoot name cfg)}
            mkdir -p "$GIT_PROJECT_ROOT"
            cd "$GIT_PROJECT_ROOT"
            ${lib.concatLines (
              lib.flip lib.mapAttrsToList cfg.repos (
                name: repo: ''
                  ln -s ${lib.escapeShellArg repo.path} ${lib.escapeShellArg name}
                ''
              )
            )}
          '';
        }
      )
    );

    services.nginx.enable = true;

    services.nginx.virtualHosts = lib.mkMerge (
      lib.mapAttrsToList (name: cfg: {
        ${cfg.nginx.virtualHost} = {
          locations =
            (genAttrs' [ "cgit.css" "cgit.png" "favicon.ico" "robots.txt" ] (
              fileName:
              lib.nameValuePair "= ${stripLocation cfg}/${fileName}" {
                alias = lib.mkDefault "${cfg.package}/cgit/${fileName}";
              }
            ))
            // {
              "~ ${regexLocation cfg}/.+/(info/refs|git-upload-pack)" = {
                fastcgiParams = rec {
                  SCRIPT_FILENAME = "${pkgs.git}/libexec/git-core/git-http-backend";
                  GIT_HTTP_EXPORT_ALL = "1";
                  GIT_PROJECT_ROOT = gitProjectRoot name cfg;
                  HOME = GIT_PROJECT_ROOT;
                };
                extraConfig = mkFastcgiPass name cfg;
              };
              "${stripLocation cfg}/" = {
                fastcgiParams = {
                  SCRIPT_FILENAME = "${cfg.package}/cgit/cgit.cgi";
                  QUERY_STRING = "$args";
                  HTTP_HOST = "$server_name";
                  CGIT_CONFIG = mkCgitrc cfg;
                };
                extraConfig = mkFastcgiPass name cfg;
              };
            };
        };
      }) cfgs
    );
  };
}
