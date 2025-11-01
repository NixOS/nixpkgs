{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cgit;

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

  vhostOptions = {
    options = {
      package = lib.mkPackageOption pkgs "cgit" {
        extraDescription = "The cgit package cannot be overwritten per location because cgit expects its static files to be available at `/cgit.css` and so forth.";
      };

      locations = lib.mkOption {
        description = "Declarative configuration of cgit locations";
        type = with lib.types; attrsOf (submodule locationOptions);
        default = { };
        example = lib.literalExpression ''
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
        type = with lib.types; nullOr path;
        default = null;
        example = "/var/lib/git";
      };

      user = lib.mkOption {
        description = ''
          User to run the cgit service, or rather its fcgiwrap instance, as.

          fcgiwrap instances are reused if they share the same user and group.
        '';
        type = lib.types.str;
        default = "cgit";
      };

      group = lib.mkOption {
        description = ''
          Group to run the cgit service, or rather its fcgiwrap instance, as.

          fcgiwrap instances are reused if they share the same user and group.
        '';
        type = lib.types.str;
        default = "cgit";
      };

      settings = lib.mkOption {
        description = "cgit configuration, see cgitrc(5)";
        type = lib.types.attrsOf settingType;
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

      locationConfig = lib.mkOption {
        description = "Additional declarative location config for nginx";
        type = lib.types.submodule (
          import ../web-servers/nginx/location-options.nix { inherit lib config; }
        );
        default = { };
        example = lib.literalExpression ''
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
    lib.replaceStrings special (map (c: "\\${c}") special);

  stripLocation = lib.removeSuffix "/";

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
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList cgitrcLine ({ virtual-root = loc; } // locCfg.settings)
      )}
      ${lib.optionalString (locCfg.scanPath != null) (cgitrcLine "scan-path" locCfg.scanPath)}

      # repository settings
      ${lib.concatStrings (
        lib.mapAttrsToList (url: settings: ''
          ${cgitrcLine "repo.url" url}
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: cgitrcLine "repo.${name}") settings)}
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
        ${lib.concatStrings (
          lib.mapAttrsToList (name: value: ''
            ln -s ${lib.escapeShellArg value.path} "$out"/${lib.escapeShellArg name}
          '') locCfg.repos
        )}
      '';

in
{
  options = {
    services.cgit = {
      enable = lib.mkEnableOption "cgit";

      virtualHosts = lib.mkOption {
        description = "Declarative configuration of cgit virtual hosts";
        type = with lib.types; attrsOf (submodule vhostOptions);
        default = { };
        example = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {
    assertions = lib.concatLists (
      lib.mapAttrsToList (
        vhost: vhostCfg:
        lib.mapAttrsToList (loc: locCfg: {
          assertion = (locCfg.scanPath == null) != (locCfg.repos == { });
          message = ''
            Exactly one of services.cgit.virtualHosts.${vhost}.locations.${loc}.scanPath
            or services.cgit.virtualHosts.${vhost}.locations.${loc}.repos must be set.
          '';
        }) vhostCfg.locations
      ) cfg.virtualHosts
    );

    users = lib.mkMerge (
      lib.concatMap (
        vhostCfg:
        lib.flip lib.mapAttrsToList vhostCfg.locations (
          _: locCfg: {
            users.${locCfg.user} = {
              isSystemUser = true;
              inherit (locCfg) group;
            };
            groups.${locCfg.group} = { };
          }
        )
      ) (lib.attrValues cfg.virtualHosts)
    );

    services.fcgiwrap.instances = lib.mkMerge (
      lib.flip lib.mapAttrsToList cfg.virtualHosts (
        _: vhostCfg:
        lib.flip lib.mapAttrs' vhostCfg.locations (
          loc: locCfg:
          lib.nameValuePair (fcgiwrapInstanceName { inherit (locCfg) user group; }) {
            process = { inherit (locCfg) user group; };
            socket = { inherit (config.services.nginx) user group; };
          }
        )
      )
    );

    systemd.services =
      let
        safeDirectoriesByUnit = lib.zipAttrsWith (_: lib.concatLists) (
          lib.concatMap (
            vhostCfg:
            map (locCfg: {
              ${fcgiwrapUnitName { inherit (locCfg) user group; }} =
                # safe.directory supports trailing /*, use it for scanPath
                # https://git-scm.com/docs/git-config/2.36.0#Documentation/git-config.txt-safedirectory
                lib.optional (locCfg.scanPath != null) "${locCfg.scanPath}/*"
                ++ map (name: "${gitProjectRoot locCfg}/${name}") (lib.attrNames locCfg.repos);
            }) (lib.attrValues vhostCfg.locations)
          ) (lib.attrValues cfg.virtualHosts)
        );
      in
      lib.mapAttrs (_: safeDirectories: {
        # see https://git-scm.com/docs/git-config/2.36.0#Documentation/git-config.txt-GITCONFIGCOUNT
        environment = (
          {
            GIT_CONFIG_COUNT = toString (lib.length safeDirectories);
          }
          // lib.mergeAttrsList (
            lib.imap0 (i: directory: {
              "GIT_CONFIG_KEY_${toString i}" = "safe.directory";
              "GIT_CONFIG_VALUE_${toString i}" = directory;
            }) safeDirectories
          )
        );
        serviceConfig.ExecStartPre = [
          "${lib.getExe pkgs.git} config get --all --show-names safe.directory"
        ];
      }) safeDirectoriesByUnit;

    services.nginx = {
      enable = true;
      virtualHosts = lib.mapAttrs (_: vhostCfg: {
        locations = lib.mkMerge (
          lib.optionals (vhostCfg.locations != { }) (
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
          ++ (lib.mapAttrsToList (loc: locCfg: {
            "~ ${regexLocation loc}/.+/(info/refs|git-upload-pack)" = lib.mkMerge [
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
            "${stripLocation loc}/" = lib.mkMerge [
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
