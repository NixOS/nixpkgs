{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    removeAttrs
    pipe
    hasPrefix
    removePrefix
    filter
    optionalString
    zipListsWith
    mkOption
    types
    foldAttrs
    mergeAttrs
    mkEnableOption
    literalExpression
    foldl
    optional
    ;

  cfg = config.services.keymapper;

  generateDirectives = "@forward-modifiers " + (concatStringsSep " " cfg.forwardModifiers);

  generateAliases = aliases: concatStringsSep "\n" (mapAttrsToList (n: v: n + " = " + v) aliases);

  generateConfig =
    settings:
    let
      genContextDefinition =
        context:
        let
          contextBody = pipe (removeAttrs context [ "stage" ]) [
            (mapAttrsToList (
              n: v:
              if hasPrefix "no" n && v != null then
                ''${removePrefix "no" n}!="${v}"''
              else if v != null then
                ''${n}="${v}"''
              else
                null
            ))
            (filter (x: x != null))
            (concatStringsSep " ")
          ];
        in
        (optionalString context.stage "[stage]")
        + (optionalString (context.stage && contextBody != "") "\n\n")
        + (optionalString (contextBody != "") "[${contextBody}]");

      genMappingDefinition =
        mappings:
        optionalString (mappings != [ ]) (
          concatStringsSep "\n" (map (v: "${v.input} >> ${v.output}") mappings)
        );

      contextDefinitions = map (x: genContextDefinition (removeAttrs x [ "mappings" ])) settings;
      mappingDefinitions = map (x: genMappingDefinition x.mappings) settings;
    in
    optionalString (settings != [ ]) (
      concatStringsSep "\n\n" (
        zipListsWith (
          a: b:
          if a == "" then
            b
          else if b == "" then
            a
          else
            a + "\n" + b
        ) contextDefinitions mappingDefinitions
      )
    );

  mkContextOption = name: example: desc: {
    ${name} = mkOption {
      type = types.nullOr types.str;
      default = null;
      inherit example;
      description = desc + " where the mappings are enabled.";
    };
    "no${name}" = mkOption {
      type = types.nullOr types.str;
      default = null;
      visible = false;
    };
  };

  mappingModule = types.submodule {
    options = {
      input = mkOption {
        type = types.str;
        description = "Input expression of a mapping.";
      };
      output = mkOption {
        type = types.str;
        description = "Output expression of a mapping.";
      };
    };
  };

  contextModule = types.submodule {
    options =
      (foldAttrs mergeAttrs { } [
        (mkContextOption "system" "Linux" "The system")
        (mkContextOption "title" "Chromium" "The focused window by title")
        (mkContextOption "class" "qtcreator" "The focused window by class name")
        (mkContextOption "path" "notepad.exe" "Process path")
        (mkContextOption "device" null "Input device an event originates from")
        (mkContextOption "device_id" null "Input device an event originates from")
        (mkContextOption "modifier" "Virtual1 !Virtual2" "State of one or more keys")
      ])
      // {
        stage = mkEnableOption null // {
          description = ''
            Whether to split the configuration into stages.
            This option is equivalent to adding `[stage]` to the {file}`keymapper.conf`.";
          '';
        };
        mappings = mkOption {
          type = types.listOf mappingModule;
          default = [ ];
          example = literalExpression ''
            [
              { input = "CapsLock"; output = "Backspace"; }
              { input = "Z"; output = "Y"; }
              { input = "Y"; output = "Z"; }
              { input = "Control{Q}"; output = "Alt{F4}"; }
            ]
          '';
          description = ''
            Declaration of mappings. The order of the list is reflected in the config file.
          '';
        };
      };
  };
in
{
  options.services.keymapper = {
    enable = lib.mkEnableOption ''
      keymapper, A cross-platform context-aware key remapper.

      The program is split into two parts:
      - {command}`keymapperd` is the service which needs to be given the permissions to grab the keyboard devices and inject keys.
      - {command}`keymapper` should be run as normal user in a graphical environment. It loads the configuration, informs the service about it and the active context and also executes mapped terminal commands.
      This module only enables {command}`keymapperd`. You have to add {command}`keymapper` to the desktop environment's auto-started application.
    '';

    package = lib.mkPackageOption pkgs "keymapper" { };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        {
          Win = "Meta";
          Alt = "AltLeft | AltRight";
        }
      '';
      description = "Aliases of keys and/or sequences.";
    };

    contexts = mkOption {
      type = types.listOf contextModule;
      default = [ ];
      example = literalExpression ''
        [
          {
            mappings = [
              { input = "CapsLock"; output = "Backspace"; }
              { input = "Z"; output = "Y"; }
              { input = "Y"; output = "Z"; }
              { input = "Control{Q}"; output = "Alt{F4}"; }
            ];
          }
          { stage = true; }
          {
            system = "Linux";
            noclass = "Thunar";
            mappings = [
              { input = "Control{H}"; output = "Backspace"; }
              { input = "Control{M}"; output = "Enter"; }
            ];
          }
        ]
      '';
      description = ''
        Enable mappings only in specific contexts or if only {option}`mappings`
        is specified then it is enabled unconditionally.

        Prepend "no" to the option's name (not applicable for {option}`mappings` and {option}`stage`)
        to indicate reverse option.
        For example, {option}`system` will activate the mappings in specified
        system but {option}`nosystem` will activate it in all systems except
        the one specified.

        If at least one of the context is specified but {option}`mappings` is
        left unspecified, then the context shares {option}`mappings` of the next context.
      '';
    };

    forwardModifiers = mkOption {
      type = types.listOf types.str;
      default = [
        "Shift"
        "Control"
        "Alt"
      ];
      description = ''
        Allows to set a list of keys which should never be [held back](https://github.com/houmain/keymapper?tab=readme-ov-file#order-of-mappings).
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines to add.";
    };

    extraConfigFirst = mkEnableOption null // {
      description = "Whether to put lines in {option}`extraConfig` before {option}`contexts`";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."keymapper.conf".text =
      concatStringsSep "\n\n" (
        foldl (acc: x: acc ++ (optional (x != "") x)) [ ] (
          if !cfg.extraConfigFirst then
            [
              generateDirectives
              (generateAliases cfg.aliases)
              (generateConfig cfg.contexts)
              cfg.extraConfig
            ]
          else
            [
              generateDirectives
              (generateAliases cfg.aliases)
              cfg.extraConfig
              (generateConfig cfg.contexts)
            ]
        )
      )
      + "\n";

    systemd.services.keymapperd = {
      description = "Keymapper Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/keymapperd -v";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ spitulax ];
}
