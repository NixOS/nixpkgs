{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.printers;

  inherit (lib)
    concatLines
    escapeShellArg
    mkOption
    ;

  inherit (lib.types)
    attrsOf
    listOf
    nullOr
    str
    submodule
    ;

  # "graph but not # or /" can't be implemented as regex alone due to missing lookahead support
  noInvalidChars = str: lib.all (c: c != "#" && c != "/") (lib.stringToCharacters str);
  printerName = (lib.types.addCheck (lib.types.strMatching "[[:graph:]]+") noInvalidChars) // {
    description = "printable string without spaces, # and /";
  };
in
{
  options = {
    hardware.printers = {
      ensureDefaultPrinter = lib.mkOption {
        type = lib.types.nullOr printerName;
        default = null;
        description = ''
          Ensures the named printer is the default CUPS printer / printer queue.
        '';
      };
      ensureClasses = mkOption {
        description = ''
          Will ensure that the given CUPS classes are configured as declared.
          Please note that it is possible for some users to temporarily override
          these properties. If those changes conflict with this configuration,
          the configuration will take precedence and override them at boot and
          when a rebuild is applied. This configuration will not delete any
          classes that have been removed from the list. In order to list classes
          you can use {command}`lpstat -c`. It will list any classes without
          members as having a member titled `unknown`. Print jobs to empty
          classes will silently fail. In order to remove a class, run
          {command}`lpadmin -x <class name>`. Classes can still be added
          manually. For more on classes see
          <https://www.cups.org/doc/admin.html#CLASSES>, or
          {manpage}`lpadmin(8)`.
        '';
        type = attrsOf (submodule {
          options = {
            description = mkOption {
              type = nullOr str;
              description = "Optional human-readable description";
              example = "Printers that support color printing";
            };
            location = mkOption {
              type = nullOr str;
              description = "Optional human-readable location";
              example = "Workroom";
            };
            printers = mkOption {
              type = listOf str;
              default = [ ];
              example = [
                "BrotherHL_Workroom"
                "EpsonColor_Basement"
              ];
              description = ''
                A list of printers included in this class. Note that all
                printers in this list must also be present in
                config.hardware.printers.ensurePrinters. Specifying a symblic
                name here that does not match any of those printers is
                considered a hard error.

                ::: {.warning}
                Print jobs to this class will quietly fail if there are no
                printers in this class. CUPS reports them as pending
                :::
              '';
            };
            classes = mkOption {
              type = listOf str;
              default = [ ];
              description = ''
                A list of classes to include in this class.

                ::: {.note}
                CUPS itself does not support nested classes. Any classes will
                simply have all of their member printers added to this class
                in a recursive manner. This is an abstraction that serves the
                purpose of convenience and expressiveness, not a 1:1 mapping
                on top of CUPS.
                :::
              '';
            };
          };
        });
      };
      ensurePrinters = lib.mkOption {
        description = ''
          Will regularly ensure that the given CUPS printers are configured as declared here.
          If a printer's options are manually changed afterwards, they will be overwritten eventually.
          This option will never delete any printer, even if removed from this list.
          You can check existing printers with {command}`lpstat -s`
          and remove printers with {command}`lpadmin -x <printer-name>`.
          Printers not listed here can still be manually configured.
        '';
        default = [ ];
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = printerName;
                example = "BrotherHL_Workroom";
                description = ''
                  Name of the printer / printer queue.
                  May contain any printable characters except "/", "#", and space.
                '';
              };
              location = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "Workroom";
                description = ''
                  Optional human-readable location.
                '';
              };
              description = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "Brother HL-5140";
                description = ''
                  Optional human-readable description.
                '';
              };
              deviceUri = lib.mkOption {
                type = lib.types.str;
                example = lib.literalExpression ''
                  "ipp://printserver.local/printers/BrotherHL_Workroom"
                  "usb://HP/DESKJET%20940C?serial=CN16E6C364BH"
                '';
                description = ''
                  How to reach the printer.
                  {command}`lpinfo -v` shows a list of supported device URIs and schemes.
                '';
              };
              model = lib.mkOption {
                type = lib.types.str;
                example = lib.literalExpression ''
                  "gutenprint.''${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://brother-hl-5140/expert"
                '';
                description = ''
                  Location of the ppd driver file for the printer.
                  {command}`lpinfo -m` shows a list of supported models.
                '';
              };
              ppdOptions = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                example = {
                  PageSize = "A4";
                  Duplex = "DuplexNoTumble";
                };
                default = { };
                description = ''
                  Sets PPD options for the printer.
                  {command}`lpoptions [-p printername] -l` shows supported PPD options for the given printer.
                '';
              };
            };
          }
        );
      };
    };
  };

  config.assertions = lib.mkIf config.services.printing.enable [
    (
      let
        referencedClasses = lib.unique (
          lib.flatten (
            lib.mapAttrsToList (
              _:
              {
                classes ? [ ],
                ...
              }:
              classes
            ) cfg.ensureClasses
          )
        );
        definedClasses = lib.attrNames cfg.ensureClasses;
        missingClasses = lib.subtractLists definedClasses referencedClasses;
        getReferencingClasses =
          missingClass:
          (lib.mapAttrsToList (name: _: "`${name}`") (
            lib.filterAttrs (
              _:
              {
                classes ? [ ],
                ...
              }:
              builtins.elem missingClass classes
            ) cfg.ensureClasses
          ));
      in
      {
        assertion = missingClasses == [ ];
        message = ''
          One or more values of `config.hardware.printers.ensureClasses.<name>.classes`
          contained values not present in `config.hardware.printers.ensureClasses`

          Missing classes:
          ${lib.concatMapStringsSep "\n" (
            p: "  - `${p}` (included in class(es): ${lib.concatStringsSep ", " (getReferencingClasses p)})"
          ) missingClasses}
        '';
      }
    )

    (
      let
        referencedPrinters = lib.unique (
          lib.flatten (
            lib.mapAttrsToList (
              _:
              {
                printers ? [ ],
                ...
              }:
              printers
            ) cfg.ensureClasses
          )
        );
        definedPrinters = lib.catAttrs "name" cfg.ensurePrinters;
        missingPrinters = lib.subtractLists definedPrinters referencedPrinters;
        getReferencingClasses =
          missingPrinter:
          (lib.mapAttrsToList (name: _: "`${name}`") (
            lib.filterAttrs (
              _:
              {
                printers ? [ ],
                ...
              }:
              builtins.elem missingPrinter printers
            ) cfg.ensureClasses
          ));
      in
      {
        assertion = missingPrinters == [ ];
        message = ''
          One or more values of `config.hardware.printers.ensureClasses.<name>.printers`
          contained values not present in `config.hardware.printers.ensurePrinters`

          Missing printers:
          ${lib.concatMapStringsSep "\n" (
            p: "  - `${p}` (included in class(es): ${lib.concatStringsSep ", " (getReferencingClasses p)})"
          ) missingPrinters}
        '';
      }
    )
  ];

  config.systemd.services = lib.mkIf config.services.printing.enable {
    cups = {
      serviceConfig = {
        ExecStartPost =
          let
            getPrinters =
              class:
              lib.uniqueStrings (
                lib.concatLists (
                  lib.textClosureList (lib.mapAttrs (
                    _:
                    {
                      classes ? [ ],
                      printers ? [ ],
                      ...
                    }:
                    {
                      deps = classes;
                      text = printers;
                    }
                  ) cfg.ensureClasses) [ class ]
                )
              );

            classNames = builtins.attrNames cfg.ensureClasses;

            lpadmin =
              args:
              let
                # -d, -p and -x are subcommands that must be specified at the start.
                argsDpx = lib.intersectAttrs {
                  d = true;
                  p = true;
                  x = true;
                } args;
                argsWoDpx = lib.removeAttrs args [
                  "d"
                  "p"
                  "x"
                ];
              in
              "lpadmin ${lib.cli.toCommandLineShellGNU { } argsDpx} ${
                lib.cli.toCommandLineShellGNU { } argsWoDpx
              }";

            postExecScript = pkgs.writeShellApplication {
              name = "cups-provisioning.sh";
              runtimeInputs = [ pkgs.cups ];
              text = ''
                #### ADDING PRINTERS ####
                ${lib.concatMapStringsSep "\n" (
                  p:
                  lpadmin {
                    p = p.name;
                    v = p.deviceUri;
                    m = p.model;
                    L = p.location;
                    D = p.description;
                    o = lib.mapAttrsToList (name: value: "${name}=${value}") p.ppdOptions;
                    E = true;
                  }
                ) cfg.ensurePrinters}

                #### SETTING DEFAULT PRINTER ####
                ${lib.optionalString (cfg.ensureDefaultPrinter != null) (lpadmin {
                  d = cfg.ensureDefaultPrinter;
                })}

                #### CLASS DEFINITIONS ####
                lpadmin -p _tmp -v file:/dev/null
                ${lib.concatMapStringsSep "\n" (
                  className:
                  lpadmin {
                    p = "_tmp";
                    c = className;
                  }
                ) classNames}
                lpadmin -x _tmp

                #### ADDING PRINTERS TO CLASSES ####
                ${lib.concatMapStringsSep "\n" (
                  className:
                  lib.concatMapStringsSep "\n" (
                    printer:
                    lpadmin {
                      p = printer;
                      c = className;
                    }
                  ) (getPrinters className)
                ) classNames}

                #### POPULATING CLASSES ####
                ${lib.concatStringsSep "\n" (
                  lib.mapAttrsToList (
                    className: class:
                    lpadmin {
                      p = className;
                      L = class.location;
                      D = class.description;
                    }
                  ) cfg.ensureClasses
                )}

                #### ENABLING CLASSES ####
                ${lib.concatMapStrings (className: ''
                  cupsenable ${escapeShellArg className}
                  cupsaccept ${escapeShellArg className}
                '') classNames}

                echo "CUPS provisioning complete."
              '';
            };
          in
          lib.getExe postExecScript;
      };
    };
  };
}
