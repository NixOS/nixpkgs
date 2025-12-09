{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.scanbd;

  # Utility functions for structured configuration rendering
  utils = rec {
    # Smart value renderer for scanbd config format
    renderValue =
      value:
      if builtins.isAttrs value then
        "{ }" # Empty block notation
      else if builtins.isBool value then
        if value then "true" else "false"
      else if builtins.isString value then
        ''"${value}"''
      else
        builtins.toString value;

    # Renders an attribute set as formatted key-value pairs
    renderAttrSet =
      {
        attrs,
        indent ? 0,
      }:
      let
        mkKeyValue =
          k: v:
          lib.concatStrings (
            lib.replicate indent " "
            ++ [
              k
              " = "
              (renderValue v)
            ]
          );
      in
      lib.concatStringsSep "\n" (lib.mapAttrsToList mkKeyValue attrs);

    # Renders a named configuration block
    renderBlock =
      {
        name,
        content,
        indent ? 0,
      }:
      let
        indentStr = lib.concatStrings (lib.replicate indent " ");
      in
      ''
        ${indentStr}${name} {
        ${content}
        ${indentStr}}
      '';

    # Renders a scanbd action block with nested trigger
    renderAction =
      {
        name,
        attrs,
        trigger,
        indent ? 2,
      }:
      let
        # Render trigger block
        triggerContent = renderAttrSet {
          attrs = builtins.removeAttrs trigger [ "type" ];
          indent = indent + 4;
        };

        triggerBlock = renderBlock {
          name = trigger.type;
          content = triggerContent;
          indent = indent + 2;
        };

        # Render main action attributes
        actionAttrs = renderAttrSet {
          inherit attrs;
          indent = indent + 2;
        };

        # Combine trigger and attributes
        actionContent = lib.concatStringsSep "\n" [
          actionAttrs
          triggerBlock
        ];
      in
      renderBlock {
        name = "action ${name}";
        content = actionContent;
        inherit indent;
      };

    # Renders a scanbd device block with attributes and optional actions
    renderDevice =
      {
        name,
        filter,
        desc ? "",
        actions ? { },
        indent ? 2,
      }:
      let
        # Render device attributes
        deviceAttrs = renderAttrSet {
          attrs = {
            inherit filter;
          }
          // lib.optionalAttrs (desc != "") { inherit desc; };
          indent = indent + 2;
        };

        # Render device-specific actions
        deviceActions = lib.concatMapAttrsStringSep "\n\n" (
          actionName: actionCfg:
          renderAction {
            name = actionName;
            inherit (actionCfg) attrs trigger;
            indent = indent + 2;
          }
        ) actions;

        # Combine attributes and actions
        deviceContent = lib.concatStringsSep "\n\n" (
          [ deviceAttrs ] ++ lib.optional (actions != { }) deviceActions
        );
      in
      renderBlock {
        name = "device ${name}";
        content = deviceContent;
        inherit indent;
      };
  };

  # Process actions to generate scripts for scan actions without custom scripts
  processedActions = lib.mapAttrs (
    name: actionCfg:
    if name == "scan" && actionCfg.script == null then
      actionCfg
      // {
        script = pkgs.runCommand "scanbd-scan-script" { } ''
          install -Dm755 ${
            pkgs.replaceVars ./scanbd-builtin-scan-script.sh {
              # Package paths
              inherit (pkgs) coreutils imagemagick ghostscript;

              # Configuration values from action
              inherit (actionCfg)
                outputDirectory
                scanSource
                scanMode
                scanResolution
                pdfDensity
                pdfCompression
                pdfSettings
                ;

              # Resolve scannerBinary to full path if it's the default
              scannerBinary =
                if actionCfg.scannerBinary == "scanadf" then
                  "${pkgs.sane-frontends}/bin/scanadf"
                else
                  actionCfg.scannerBinary;
            }
          } $out
        '';
      }
    else
      actionCfg
  ) cfg.actions;

  # Collect all scripts from global actions and device-specific actions
  # Wrap each script to ensure shebangs are patched and scripts are executable
  allScripts =
    let
      wrapScript = name: path: lib.nameValuePair name (pkgs.writeShellScript name ''${path} "$@"'');
    in
    # Global action scripts (use processedActions which includes generated scan scripts)
    lib.listToAttrs (
      lib.mapAttrsToList (name: action: wrapScript "${name}.script" action.script) processedActions
    )
    # Device-specific action scripts
    // lib.listToAttrs (
      lib.flatten (
        lib.mapAttrsToList (
          deviceName: deviceCfg:
          lib.mapAttrsToList (
            actionName: action: wrapScript "${deviceName}-${actionName}.script" action.script
          ) deviceCfg.actions
        ) cfg.devices
      )
    );

  # Build scripts directory
  scriptsDir = pkgs.runCommand "scanbd-scripts" { } ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: path: "ln -s ${path} $out/${name}") allScripts
    )}
  '';

  # Structured configuration for scanbd global settings
  globalConfig = {
    debug = cfg.verbosity > 0;
    debug-level = cfg.verbosity;
    user = "scanner";
    group = "scanner";
    scriptdir = toString scriptsDir;
    pidfile = "/run/scanbd.pid";
    saned = "${pkgs.sane-backends}/bin/saned";
    saned_opt = { };
    timeout = cfg.timeout;
    multiple_actions = true;
  };

  # Environment configuration (special section, not an option)
  # Values are env var names, not quoted strings
  environmentBlock = ''
    environment {
      device = "SCANBD_DEVICE"
      action = "SCANBD_ACTION"
    }'';

  # saned_env configuration (rendered as an option assignment, not a block)
  sanedEnvBlock = ''
    saned_env = {
      "SANE_CONFIG_DIR=${toString config.hardware.sane.configDir}"
    }'';

  # Render all actions
  renderedActions = lib.concatMapAttrsStringSep "\n\n" (
    name: actionCfg:
    utils.renderAction {
      inherit name;
      attrs = {
        inherit (actionCfg) filter;
        script = "${name}.script";
      }
      // lib.optionalAttrs (actionCfg.desc != "") { inherit (actionCfg) desc; };
      inherit (actionCfg) trigger;
    }
  ) processedActions;

  # Render all devices
  renderedDevices = lib.concatMapAttrsStringSep "\n\n" (
    name: deviceCfg:
    utils.renderDevice {
      inherit name;
      inherit (deviceCfg) filter desc;
      # Transform actions to include generated script names
      actions = lib.mapAttrs (actionName: actionCfg: {
        attrs = {
          inherit (actionCfg) filter;
          script = "${name}-${actionName}.script";
        }
        // lib.optionalAttrs (actionCfg.desc != "") { inherit (actionCfg) desc; };
        inherit (actionCfg) trigger;
      }) deviceCfg.actions;
    }
  ) cfg.devices;

  # Render global configuration attributes
  renderedGlobalAttrs = utils.renderAttrSet {
    attrs = globalConfig;
    indent = 2;
  };

  # Combine all parts into the final global block
  # Helper to add 2-space indentation to each line
  indent = text: lib.concatMapStringsSep "\n" (line: "  ${line}") (lib.splitString "\n" text);

  globalBlockContent = lib.concatStringsSep "\n\n" (
    [
      renderedGlobalAttrs
      (indent sanedEnvBlock)
      (indent environmentBlock)
      renderedActions
      renderedDevices
    ]
    ++ lib.optional (cfg.extraConfig != "") ("  " + cfg.extraConfig)
  );

  scanbdConf = pkgs.writeText "scanbd.conf" (
    utils.renderBlock {
      name = "global";
      content = globalBlockContent;
      indent = 0;
    }
  );

  # SANE config points directly to hardware.sane.configDir
  saneConfigDir = config.hardware.sane.configDir;

in

{
  meta = {
    maintainers = with lib.maintainers; [ csingley ];
  };

  ###### interface

  options.services.scanbd = {

    enable = lib.mkEnableOption "scanbd scanner button daemon" // {
      description = ''
        Enable scanbd scanner button daemon for monitoring scanner buttons
        and automating scan workflows.

        Note: Cannot be enabled simultaneously with services.saned.
      '';
      example = lib.literalExpression ''
        {
          # Simple setup with automatic PDF scanning to paperless
          services.scanbd = {
            enable = true;
            actions.scan = {
              outputDirectory = "/var/lib/paperless/consume";
              scanSource = "ADF Duplex";
              scanMode = "Gray";
              scanResolution = "200dpi";
            };
          };

          # Advanced setup with scanimage and multiple actions
          services.scanbd = {
            enable = true;
            actions = {
              scan = {
                scannerBinary = "''${pkgs.sane-backends}/bin/scanimage";
                outputDirectory = "/srv/scans";
                scanSource = "Flatbed";
                scanMode = "Color";
              };
              email = {
                script = pkgs.writeShellScript "email-scan" '''
                  # Custom email scanning script
                ''';
              };
            };
          };
        }
      '';
    };

    package = lib.mkPackageOption pkgs "scanbd" { };

    verbosity = lib.mkOption {
      type = lib.types.ints.between 0 7;
      default = 3;
      description = ''
        Logging verbosity level (0=disabled, 1=error, 2=warn, 3=info, 4-7=debug).
      '';
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 500;
      description = "Device polling timeout in milliseconds.";
    };

    actions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              filter = lib.mkOption {
                type = lib.types.str;
                default = "^${name}.*";
                description = "Filter pattern for matching scanner button/function";
                example = "^scan.*";
              };
              desc = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Human-readable action description (optional)";
                example = "Scan to file";
              };
              script = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = ''
                  Path to executable script. Scripts are automatically wrapped to ensure
                  shebangs are patched for NixOS. Can be:
                  - Local file path (e.g., `./scan.sh`)
                  - Inline script using `pkgs.writeScript` or `pkgs.writeShellScript`
                  - Binary from a package (e.g., `"''${pkgs.some-package}/bin/tool"`)

                  For the "scan" action, if null, a default PDF scanning script will be
                  generated using the PDF options below.
                '';
                example = lib.literalExpression ''
                  pkgs.writeShellScript "scan" '''
                    scanadf -d "$SCANBD_DEVICE" --source "ADF Duplex"
                    # ... process scanned images ...
                  '''
                '';
              };
              trigger = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    type = lib.mkOption {
                      type = lib.types.enum [
                        "numerical-trigger"
                        "string-trigger"
                      ];
                      default = "numerical-trigger";
                      description = "Type of trigger";
                    };
                    from-value = lib.mkOption {
                      type = lib.types.either lib.types.int lib.types.str;
                      default = 1;
                      description = "Trigger from-value";
                    };
                    to-value = lib.mkOption {
                      type = lib.types.either lib.types.int lib.types.str;
                      default = 0;
                      description = "Trigger to-value";
                    };
                  };
                };
                default = { };
                description = "Action trigger configuration";
              };

              # PDF Scan Options (only used for "scan" action when script is null)
              outputDirectory = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "/var/lib/paperless/consume";
                description = ''
                  Directory where scanned documents will be saved.
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              scannerBinary = lib.mkOption {
                type = lib.types.str;
                default = "scanadf";
                defaultText = lib.literalExpression ''"''${pkgs.sane-frontends}/bin/scanadf"'';
                description = ''
                  Scanner command to use for the default PDF scan script.

                  Supported commands:
                  - `scanadf` (default): Batch scanner from sane-frontends, designed for ADF
                  - `scanimage`: Standard SANE frontend with --batch mode support
                  - Custom scanner command: Will attempt scanadf-compatible invocation

                  The default script automatically detects the command type and adjusts
                  its behavior accordingly. For full control, provide a custom `script`.

                  Only used for "scan" action when no custom script is provided.
                '';
              };

              scanSource = lib.mkOption {
                type = lib.types.str;
                default = "Flatbed";
                example = "ADF Duplex";
                description = ''
                  Scanner source (Flatbed, ADF, ADF Duplex, etc.)
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              scanMode = lib.mkOption {
                type = lib.types.str;
                default = "Color";
                example = "Gray";
                description = ''
                  Scan color mode (Color, Gray, Lineart)
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              scanResolution = lib.mkOption {
                type = lib.types.str;
                default = "300dpi";
                example = "600dpi";
                description = ''
                  Scan resolution
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              pdfDensity = lib.mkOption {
                type = lib.types.str;
                default = "300x300";
                description = ''
                  PDF density for image conversion
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              pdfCompression = lib.mkOption {
                type = lib.types.str;
                default = "jpeg";
                example = "lzw";
                description = ''
                  PDF compression method
                  Only used for "scan" action when no custom script is provided.
                '';
              };

              pdfSettings = lib.mkOption {
                type = lib.types.str;
                default = "/ebook";
                example = "/printer";
                description = ''
                  Ghostscript PDF settings for compression
                  (/screen, /ebook, /printer, /prepress, /default)
                  Only used for "scan" action when no custom script is provided.
                '';
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Scanbd actions configuration. Each action responds to scanner button presses
        or function knob changes and executes a script.

        The special "scan" action can use a built-in PDF scanning script by leaving
        `script = null` and configuring PDF options (outputDirectory, scanSource, etc.).
        This script supports both scanadf and scanimage automatically.

        For other actions or custom behavior, provide a script using:
        - Local file: Automatically copied to Nix store with patched shebangs
        - Inline script: Use `pkgs.writeScript` or `pkgs.writeShellScript`
        - Package binary: Reference executables from packages
      '';
      example = lib.literalExpression ''
        {
          # Default PDF scan action with scanadf (default)
          scan = {
            # filter, trigger have smart defaults
            outputDirectory = "/var/lib/paperless/consume";
            scanSource = "ADF Duplex";
            scanMode = "Gray";
            scanResolution = "200dpi";
          };

          # Or use scanimage instead
          scan = {
            outputDirectory = "/var/lib/paperless/consume";
            scannerBinary = "''${pkgs.sane-backends}/bin/scanimage";
            scanSource = "ADF";
            scanMode = "Color";
            scanResolution = "300";
          };

          # Or completely custom scan script
          scan = {
            script = pkgs.writeShellScript "custom-scan" '''
              #!/usr/bin/env bash
              # Your custom scanning logic here
              scanimage -d "$SCANBD_DEVICE" --batch="scan-%04d.tiff" --format=tiff
              # ... custom processing ...
            ''';
          };

          # Email action with inline script
          email = {
            # filter defaults to "^email.*"
            desc = "Scan and email";
            script = pkgs.writeShellScript "scan-email" '''
              scanadf -d "$SCANBD_DEVICE" --output-file scan.pnm
              convert scan.pnm scan.pdf
              mail -s "Scanned document" user@example.com < scan.pdf
            ''';
          };

          # Copy action with local script file
          copy = {
            script = ./scanner-scripts/copy-to-printer.sh;
          };
        }
      '';
    };

    devices = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            filter = lib.mkOption {
              type = lib.types.str;
              description = "Device filter regex for matching scanner models";
              example = "^genesys.*";
            };
            desc = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Human-readable device description (optional)";
              example = "Canon LIDE Scanner";
            };
            actions = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule {
                  options = {
                    filter = lib.mkOption {
                      type = lib.types.str;
                      description = "Filter pattern for matching scanner button/function";
                    };
                    desc = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "Human-readable action description (optional)";
                    };
                    script = lib.mkOption {
                      type = lib.types.path;
                      description = ''
                        Path to executable script. Scripts are automatically wrapped to ensure
                        shebangs are patched for NixOS. Can be:
                        - Local file path (e.g., `./scan.sh`)
                        - Inline script using `pkgs.writeScript` or `pkgs.writeShellScript`
                        - Binary from a package (e.g., `"''${pkgs.some-package}/bin/tool"`)
                      '';
                    };
                    trigger = lib.mkOption {
                      type = lib.types.submodule {
                        options = {
                          type = lib.mkOption {
                            type = lib.types.enum [
                              "numerical-trigger"
                              "string-trigger"
                            ];
                            description = "Type of trigger";
                          };
                          from-value = lib.mkOption {
                            type = lib.types.either lib.types.int lib.types.str;
                            description = "Trigger from-value";
                          };
                          to-value = lib.mkOption {
                            type = lib.types.either lib.types.int lib.types.str;
                            description = "Trigger to-value";
                          };
                        };
                      };
                      description = "Action trigger configuration";
                    };
                  };
                }
              );
              default = { };
              description = "Device-specific actions";
            };
          };
        }
      );
      default = { };
      description = ''
        Scanner device configurations. Each device can have its own filter,
        description, and device-specific actions.

        Scripts can be provided as local files, inline scripts, or package binaries.
      '';
      example = lib.literalExpression ''
        {
          canon = {
            filter = "^genesys.*";
            desc = "Canon LIDE Scanner";
            actions = {
              # Inline script
              file = {
                filter = "^file.*";
                desc = "File button";
                script = pkgs.writeShellScript "file-button" '''
                  scanadf -d "$SCANBD_DEVICE" --output-file /tmp/scan.pdf
                  mv /tmp/scan.pdf ~/Documents/
                ''';
                trigger = {
                  type = "numerical-trigger";
                  from-value = 1;
                  to-value = 0;
                };
              };

              # Local file
              email = {
                filter = "^email.*";
                script = ./canon-email-scan.sh;
                trigger = {
                  type = "string-trigger";
                  from-value = "";
                  to-value = "^email.*";
                };
              };
            };
          };
        }
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines included verbatim in scanbd.conf global block.
        This is an escape hatch for advanced configuration not covered by other options.
      '';
      example = ''
        # Custom polling configuration
        polling-timeout = 1000
      '';
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.services.saned.enable;
        message = "services.scanbd and services.saned cannot be enabled simultaneously";
      }
      {
        assertion =
          !(cfg.actions ? scan) || cfg.actions.scan.script != null || cfg.actions.scan.outputDirectory != "";
        message = "services.scanbd.actions.scan.outputDirectory must be set when using default scan script";
      }
    ];

    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    hardware.sane.enable = lib.mkDefault true;

    networking.firewall.connectionTrackingModules = [ "sane" ];

    systemd.services.scanbd = {
      description = "Scanner Button Polling Service";
      documentation = [ "man:scanbd(8)" ];
      wantedBy = [ "multi-user.target" ];
      aliases = [ "dbus-de.kmux.scanbd.server.service" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/scanbd -c ${scanbdConf} -f";
        User = "scanner";
        Group = "scanner";
        PIDFile = "/run/scanbd.pid";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    systemd.services."scanbm@" = {
      description = "Scanner Network Service (scanbm)";
      documentation = [ "man:scanbd(8)" ];
      requires = [ "scanbm.socket" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/scanbm -c ${scanbdConf}";
        User = "scanner";
        Group = "scanner";
        StandardInput = "socket";
      };

      environment.SANE_CONFIG_DIR = saneConfigDir;
    };

    systemd.sockets.scanbm = {
      description = "scanbd/saned Network Socket";
      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = 6566;
        Accept = true;
        MaxConnections = 64;
      };
    };

    users.users.scanner = {
      uid = config.ids.uids.scanner;
      group = "scanner";
      description = "Scanner user for scanbd";
    };

    users.groups.scanner.gid = config.ids.gids.scanner;

  };
}
