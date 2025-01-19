{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.cgit;

  settingType =
    with types;
    oneOf [
      bool
      int
      str
    ];

  repeatedSettingType =
    with types;
    oneOf [
      settingType
      (listOf settingType)
    ];

  vhostOptions = {
    options = {
      package = mkPackageOption pkgs "cgit" {
        extraDescription = "The cgit package cannot be overwritten per location because cgit expects its static files to be available at `/cgit.css` and so forth.";
      };

      locations = mkOption {
        description = "Declarative configuration of cgit locations";
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
        default = { };
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

      user = mkOption {
        description = ''
          User to run the cgit service, or rather its fcgiwrap instance, as.

          fcgiwrap instances are reused if they share the same user and group.
        '';
        type = types.str;
        default = "cgit";
      };

      group = mkOption {
        description = ''
          Group to run the cgit service, or rather its fcgiwrap instance, as.

          fcgiwrap instances are reused if they share the same user and group.
        '';
        type = types.str;
        default = "cgit";
      };

      settings = mkOption {
        description = "cgit configuration, see cgitrc(5)";
        type = types.attrsOf settingType;
        default = { };
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
    replaceStrings special (map (c: "\\${c}") special);

  stripLocation = removeSuffix "/";

  regexLocation = loc: regexEscape (stripLocation loc);

  mkFastcgiPass =
    { loc, locCfg }:
    let
      inherit
        (config.services.fcgiwrap.instances.${fcgiwrapInstanceName { inherit (locCfg) user group; }})
        socket
        ;
    in
    assert socket.type == "unix";
    ''
      ${
        if loc == "/" then
          ''
            fastcgi_param PATH_INFO $uri;
          ''
        else
          ''
            fastcgi_split_path_info ^(${regexLocation loc})(/.+)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
          ''
      }fastcgi_pass unix:${socket.address};
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

  mkCgitrc =
    loc: locCfg:
    pkgs.writeText "cgitrc" ''
      # global settings
      ${concatStringsSep "\n" (mapAttrsToList cgitrcLine ({ virtual-root = loc; } // locCfg.settings))}
      ${optionalString (locCfg.scanPath != null) (cgitrcLine "scan-path" locCfg.scanPath)}

      # repository settings
      ${concatStrings (
        mapAttrsToList (url: settings: ''
          ${cgitrcLine "repo.url" url}
          ${concatStringsSep "\n" (mapAttrsToList (name: cgitrcLine "repo.${name}") settings)}
        '') locCfg.repos
      )}

      # extra config
      ${locCfg.extraConfig}
    '';

  fcgiwrapInstanceName = { user, group }: "cgit-${user}:${group}";
  fcgiwrapUnitName = { user, group }: "fcgiwrap-${fcgiwrapInstanceName { inherit user group; }}";

  gitProjectRoot =
    locCfg:
    if locCfg.scanPath != null then
      locCfg.scanPath
    else
      pkgs.runCommandLocal "cgit-repos" { } ''
        mkdir -p "$out"
        ${concatStrings (
          mapAttrsToList (name: value: ''
            ln -s ${escapeShellArg value.path} "$out"/${escapeShellArg name}
          '') locCfg.repos
        )}
      '';

in
{
  options = {
    services.cgit = {
      enable = mkEnableOption "cgit";

      virtualHosts = mkOption {
        description = "Declarative configuration of cgit virtual hosts";
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
      mapAttrsToList (
        vhost: vhostCfg:
        mapAttrsToList (loc: locCfg: {
          assertion = (locCfg.scanPath == null) != (locCfg.repos == { });
          message = ''
            Exactly one of services.cgit.virtualHosts.${vhost}.locations.${loc}.scanPath
            or services.cgit.virtualHosts.${vhost}.locations.${loc}.repos must be set.
          '';
        }) vhostCfg.locations
      ) cfg.virtualHosts
    );

    users = mkMerge (
      concatMap (
        vhostCfg:
        flip mapAttrsToList vhostCfg.locations (
          _: locCfg: {
            users.${locCfg.user} = {
              isSystemUser = true;
              inherit (locCfg) group;
            };
            groups.${locCfg.group} = { };
          }
        )
      ) (attrValues cfg.virtualHosts)
    );

    services.fcgiwrap.instances = mkMerge (
      flip mapAttrsToList cfg.virtualHosts (
        _: vhostCfg:
        flip mapAttrs' vhostCfg.locations (
          loc: locCfg:
          nameValuePair (fcgiwrapInstanceName { inherit (locCfg) user group; }) {
            process = { inherit (locCfg) user group; };
            socket = { inherit (config.services.nginx) user group; };
          }
        )
      )
    );

    systemd.services =
      let
        safeDirectoriesByUnit = zipAttrsWith (_: concatLists) (
          concatMap (
            vhostCfg:
            map (locCfg: {
              ${fcgiwrapUnitName { inherit (locCfg) user group; }} =
                # safe.directory supports trailing /*, use it for scanPath
                # https://git-scm.com/docs/git-config/2.36.0#Documentation/git-config.txt-safedirectory
                optional (locCfg.scanPath != null) "${locCfg.scanPath}/*"
                ++ map (name: "${gitProjectRoot locCfg}/${name}") (attrNames locCfg.repos);
            }) (attrValues vhostCfg.locations)
          ) (attrValues cfg.virtualHosts)
        );
      in
      mapAttrs (_: safeDirectories: {
        # see https://git-scm.com/docs/git-config/2.36.0#Documentation/git-config.txt-GITCONFIGCOUNT
        environment = (
          {
            GIT_CONFIG_COUNT = toString (length safeDirectories);
          }
          // mergeAttrsList (
            imap0 (i: directory: {
              "GIT_CONFIG_KEY_${toString i}" = "safe.directory";
              "GIT_CONFIG_VALUE_${toString i}" = directory;
            }) safeDirectories
          )
        );
        serviceConfig.ExecStartPre = [
          "${getExe pkgs.git} config get --all --show-names safe.directory"
        ];
      }) safeDirectoriesByUnit;

    services.nginx = {
      enable = true;
      virtualHosts = mapAttrs (_: vhostCfg: {
        locations = mkMerge (
          optionals (vhostCfg.locations != { }) (
            map
              (name: {
                "= /${name}".extraConfig = ''
                  alias ${vhostCfg.package}/cgit/${name};
                  auth_basic off;
                '';
              })
              [
                "cgit.css"
                "cgit.png"
                "favicon.ico"
                "robots.txt"
              ]
          )
          ++ (mapAttrsToList (loc: locCfg: {
            "~ ${regexLocation loc}/.+/(info/refs|git-upload-pack)" = mkMerge [
              locCfg.locationConfig
              {
                fastcgiParams = rec {
                  SCRIPT_FILENAME = "${pkgs.git}/libexec/git-core/git-http-backend";
                  GIT_HTTP_EXPORT_ALL = "1";
                  GIT_PROJECT_ROOT = gitProjectRoot locCfg;
                  HOME = GIT_PROJECT_ROOT;
                };
                extraConfig = mkFastcgiPass { inherit loc locCfg; };
              }
            ];
            "${stripLocation loc}/" = mkMerge [
              locCfg.locationConfig
              {
                fastcgiParams = {
                  SCRIPT_FILENAME = "${vhostCfg.package}/cgit/cgit.cgi";
                  QUERY_STRING = "$args";
                  HTTP_HOST = "$server_name";
                  CGIT_CONFIG = mkCgitrc loc locCfg;
                };
                extraConfig = mkFastcgiPass { inherit loc locCfg; };
              }
            ];
          }) vhostCfg.locations)
        );
      }) cfg.virtualHosts;
    };
  };
}
