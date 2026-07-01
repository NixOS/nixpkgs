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

  ensurePrinter =
    p:
    let
      args = lib.cli.toCommandLineShellGNU { } (
        {
          p = p.name;
          v = p.deviceUri;
          m = p.model;
        }
        // lib.optionalAttrs (p.location != null) {
          L = p.location;
        }
        // lib.optionalAttrs (p.description != null) {
          D = p.description;
        }
        // lib.optionalAttrs (p.ppdOptions != { }) {
          o = lib.mapAttrsToList (name: value: "${name}=${value}") p.ppdOptions;
        }
      );
    in
    ''
      # shellcheck disable=SC2016
      ${pkgs.cups}/bin/lpadmin ${args} -E
    '';

  ensureDefaultPrinter = name: ''
    ${pkgs.cups}/bin/lpadmin -d '${name}'
  '';

  # "graph but not # or /" can't be implemented as regex alone due to missing lookahead support
  noInvalidChars = str: lib.all (c: c != "#" && c != "/") (lib.stringToCharacters str);
  printerName = (lib.types.addCheck (lib.types.strMatching "[[:graph:]]+") noInvalidChars) // {
    description = "printable string without spaces, # and /";
  };
  getPrinters =
    class:
    assert lib.assertMsg (cfg.ensureClasses ? ${class}) "class \"${class}\" does not exist";
    let
      inherit (cfg.ensureClasses.${class})
        classes
        printers
        ;
      classPrinters = (map getPrinters classes);
    in
    lib.lists.unique (printers ++ (lib.lists.flatten classPrinters));
  mkClass = name: ''
    lpadmin -p _tmp -v file:/dev/null
    lpadmin -p _tmp -c ${escapeShellArg name}
    lpadmin -x _tmp
  '';

  populateClass =
    name:
    {
      description ? null,
      location ? null,
      ...
    }:
    lib.concatStringsSep "\n" [
      (lib.optionalString (location != null) ''
        lpadmin -p ${escapeShellArg name} -L ${escapeShellArg location}
      '')

      (lib.optionalString (description != null) ''
        lpadmin -p ${escapeShellArg name} -D ${escapeShellArg description}
      '')
    ];

  addPrintersToClass =
    className: class:
    let
      printers = getPrinters className;
      addToClass = printer: ''
        lpadmin -p ${escapeShellArg printer} -c ${escapeShellArg className}
      '';
    in
    map addToClass printers;

  enableClass = className: ''
    cupsenable ${escapeShellArg className}
    cupsaccept ${escapeShellArg className}
  '';
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
          Please note that it is possible for some users to temporarily
          override these properties. If those changes conflict with this
          configuration, the configuration will take precedence and override
          them at boot and when a rebuild is applied. This configuration will
          not delete any classes that have been removed from the list. In order
          to list classes you can use {command}`lpstat -c`. It will list any
          classes without members as having a member titled `unknown`. Print
          jobs to empty classes will silently fail. In order to remove a class,
          run {command}`lpadmin -x <class name>`. Classes can still be added
          manually. For more on classes see
          <https://www.cups.org/doc/admin.html#CLASSES>, or {command}`man
          lpadmin`.
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
              description = ''
                A list of printers included in this class.

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

  config.systemd.services.ensure-classes =
    lib.mkIf (cfg.ensureClasses != [ ] && config.services.printing.enable)
      {
        description = "Ensure NixOS-configured CUPS classes";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "cups.service"
        ];
        after = [
          "cups.service"
          "ensure-printers.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = with pkgs; [ cups ];
        script =
          let
            attrMap = fn: l: map fn (builtins.attrNames l);
            classDefs = lib.pipe cfg.ensureClasses [
              (attrMap mkClass)
              concatLines
            ];
            classAdds = lib.pipe cfg.ensureClasses [
              (lib.mapAttrsToList addPrintersToClass)
              lib.flatten
              concatLines
            ];
            populatedClasses = lib.pipe cfg.ensureClasses [
              (lib.mapAttrsToList populateClass)
              concatLines
            ];
            enables = lib.pipe cfg.ensureClasses [
              (attrMap enableClass)
              concatLines
            ];
          in
          ''
            #### CLASS DEFINITIONS ####
            ${classDefs}

            #### ADDING PRINTERS TO CLASSES ####
            ${classAdds}

            #### POPULATING CLASSES ####
            ${populatedClasses}

            #### ENABLING CLASSES ####
            ${enables}
          '';
      };

  config.systemd.services.ensure-printers =
    lib.mkIf (cfg.ensurePrinters != [ ] && config.services.printing.enable)
      {
        description = "Ensure NixOS-configured CUPS printers";
        wantedBy = [ "multi-user.target" ];
        wants = [ "cups.service" ];
        after = [ "cups.service" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = lib.concatStringsSep "\n" [
          (lib.concatMapStrings ensurePrinter cfg.ensurePrinters)
          (lib.optionalString (cfg.ensureDefaultPrinter != null) (
            ensureDefaultPrinter cfg.ensureDefaultPrinter
          ))
          # Note: if cupsd is "stateless" the service can't be stopped,
          # otherwise the configuration will be wiped on the next start.
          (lib.optionalString (
            with config.services.printing; startWhenNeeded && !stateless
          ) "systemctl stop cups.service")
        ];
      };
}
