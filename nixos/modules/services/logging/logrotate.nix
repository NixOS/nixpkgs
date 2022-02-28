{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logrotate;

  # deprecated legacy compat settings
  # these options will be removed before 22.11 in the following PR:
  # https://github.com/NixOS/nixpkgs/pull/164169
  pathOpts = { name, ... }: {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable log rotation for this path. This can be used to explicitly disable
          logging that has been configured by NixOS.
        '';
      };

      name = mkOption {
        type = types.str;
        internal = true;
      };

      path = mkOption {
        type = with types; either str (listOf str);
        default = name;
        defaultText = "attribute name";
        description = ''
          The path to log files to be rotated.
          Spaces are allowed and normal shell quoting rules apply,
          with ', ", and \ characters supported.
        '';
      };

      user = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          The user account to use for rotation.
        '';
      };

      group = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          The group to use for rotation.
        '';
      };

      frequency = mkOption {
        type = types.enum [ "hourly" "daily" "weekly" "monthly" "yearly" ];
        default = "daily";
        description = ''
          How often to rotate the logs.
        '';
      };

      keep = mkOption {
        type = types.int;
        default = 20;
        description = ''
          How many rotations to keep.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra logrotate config options for this path. Refer to
          <link xlink:href="https://linux.die.net/man/8/logrotate"/> for details.
        '';
      };

      priority = mkOption {
        type = types.int;
        default = 1000;
        description = ''
          Order of this logrotate block in relation to the others. The semantics are
          the same as with `lib.mkOrder`. Smaller values have a greater priority.
        '';
      };
    };

    config.name = name;
  };

  generateLine = n: v:
    if builtins.elem n [ "files" "priority" "enable" "global" ] || v == null then null
    else if builtins.elem n [ "extraConfig" "frequency" ] then "${v}\n"
    else if builtins.elem n [ "firstaction" "lastaction" "prerotate" "postrotate" "preremove" ]
         then "${n}\n    ${v}\n  endscript\n"
    else if isInt v then "${n} ${toString v}\n"
    else if v == true then "${n}\n"
    else if v == false then "no${n}\n"
    else "${n} ${v}\n";
  generateSection = indent: settings: concatStringsSep (fixedWidthString indent " " "") (
    filter (x: x != null) (mapAttrsToList generateLine settings)
  );

  # generateSection includes a final newline hence weird closing brace
  mkConf = settings:
    if settings.global or false then generateSection 0 settings
    else ''
      ${concatMapStringsSep "\n" (files: ''"${files}"'') (toList settings.files)} {
        ${generateSection 2 settings}}
    '';

  # below two mapPaths are compat functions
  mapPathOptToSetting = n: v:
    if n == "keep" then nameValuePair "rotate" v
    else if n == "path" then nameValuePair "files" v
    else nameValuePair n v;

  mapPathsToSettings = path: pathOpts:
    nameValuePair path (
      filterAttrs (n: v: ! builtins.elem n [ "user" "group" "name" ] && v != "") (
        (mapAttrs' mapPathOptToSetting pathOpts) //
        {
          su =
            if pathOpts.user != null
            then "${pathOpts.user} ${pathOpts.group}"
            else null;
        }
      )
    );

  settings = sortProperties (attrValues (filterAttrs (_: settings: settings.enable) (
    foldAttrs recursiveUpdate { } [
      {
        header = {
          enable = true;
          missingok = true;
          notifempty = true;
          frequency = "weekly";
          rotate = 4;
        };
        # compat section
        extraConfig = {
          enable = (cfg.extraConfig != "");
          global = true;
          extraConfig = cfg.extraConfig;
          priority = 101;
        };
      }
      (mapAttrs' mapPathsToSettings cfg.paths)
      cfg.settings
      { header = { global = true; priority = 100; }; }
    ]
  )));
  configFile = pkgs.writeText "logrotate.conf" (
    concatStringsSep "\n" (
      map mkConf settings
    )
  );

  mailOption =
    if foldr (n: a: a || n ? mail) false (attrValues cfg.settings)
    then "--mail=${pkgs.mailutils}/bin/mail"
    else "";
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "logrotate" "config" ] [ "services" "logrotate" "extraConfig" ])
  ];

  options = {
    services.logrotate = {
      enable = mkEnableOption "the logrotate systemd service" // {
        default = foldr (n: a: a || n.enable) false (attrValues cfg.settings);
        defaultText = literalExpression "cfg.settings != {}";
      };

      settings = mkOption {
        default = { };
        description = ''
          logrotate freeform settings: each attribute here will define its own section,
          ordered by priority, which can either define files to rotate with their settings
          or settings common to all further files settings.
          Refer to <link xlink:href="https://linux.die.net/man/8/logrotate"/> for details.
        '';
        type = types.attrsOf (types.submodule ({ name, ... }: {
          freeformType = with types; attrsOf (nullOr (oneOf [ int bool str ]));

          options = {
            enable = mkEnableOption "setting individual kill switch" // {
              default = true;
            };

            global = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether this setting is a global option or not: set to have these
                settings apply to all files settings with a higher priority.
              '';
            };
            files = mkOption {
              type = with types; either str (listOf str);
              default = name;
              defaultText = ''
                The attrset name if not specified
              '';
              description = ''
                Single or list of files for which rules are defined.
                The files are quoted with double-quotes in logrotate configuration,
                so globs and spaces are supported.
                Note this setting is ignored if globals is true.
              '';
            };

            frequency = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                How often to rotate the logs. Defaults to previously set global setting,
                which itself defauts to weekly.
              '';
            };

            priority = mkOption {
              type = types.int;
              default = 1000;
              description = ''
                Order of this logrotate block in relation to the others. The semantics are
                the same as with `lib.mkOrder`. Smaller values are inserted first.
              '';
            };
          };

        }));
      };

      configFile = mkOption {
        type = types.path;
        default = configFile;
        defaultText = ''
          A configuration file automatically generated by NixOS.
        '';
        description = ''
          Override the configuration file used by MySQL. By default,
          NixOS generates one automatically from <xref linkend="opt-services.logrotate.settings"/>.
        '';
        example = literalExpression ''
          pkgs.writeText "logrotate.conf" '''
            missingok
            "/var/log/*.log" {
              rotate 4
              weekly
            }
          ''';
        '';
      };

      # deprecated legacy compat settings
      paths = mkOption {
        type = with types; attrsOf (submodule pathOpts);
        default = { };
        description = ''
          Attribute set of paths to rotate. The order each block appears in the generated configuration file
          can be controlled by the <link linkend="opt-services.logrotate.paths._name_.priority">priority</link> option
          using the same semantics as `lib.mkOrder`. Smaller values have a greater priority.
          This setting has been deprecated in favor of <link linkend="opt-services.logrotate.settings">logrotate settings</link>.
        '';
        example = literalExpression ''
          {
            httpd = {
              path = "/var/log/httpd/*.log";
              user = config.services.httpd.user;
              group = config.services.httpd.group;
              keep = 7;
            };

            myapp = {
              path = "/var/log/myapp/*.log";
              user = "myuser";
              group = "mygroup";
              frequency = "weekly";
              keep = 5;
              priority = 1;
            };
          }
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra contents to append to the logrotate configuration file. Refer to
          <link xlink:href="https://linux.die.net/man/8/logrotate"/> for details.
          This setting has been deprecated in favor of
          <link linkend="opt-services.logrotate.settings">logrotate settings</link>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      mapAttrsToList
        (name: pathOpts:
          {
            assertion = (pathOpts.user != null) == (pathOpts.group != null);
            message = ''
              If either of `services.logrotate.paths.${name}.user` or `services.logrotate.paths.${name}.group` are specified then *both* must be specified.
            '';
          })
        cfg.paths;

    warnings =
      (mapAttrsToList
        (name: pathOpts: ''
          Using config.services.logrotate.paths.${name} is deprecated and will become unsupported in a future release.
          Please use services.logrotate.settings instead.
        '')
        cfg.paths
      ) ++
      (optional (cfg.extraConfig != "") ''
        Using config.services.logrotate.extraConfig is deprecated and will become unsupported in a future release.
        Please use services.logrotate.settings with globals=true instead.
      '');

    systemd.services.logrotate = {
      description = "Logrotate Service";
      startAt = "hourly";

      serviceConfig = {
        Restart = "no";
        User = "root";
        ExecStart = "${pkgs.logrotate}/sbin/logrotate ${mailOption} ${cfg.configFile}";
      };
    };
  };
}
