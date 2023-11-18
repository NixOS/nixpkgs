{ config, lib, pkgs, ... }:

let

  # cups calls its backends as user `lp` (which is good!),
  # but cups-pdf wants to be called as `root`, so it can change ownership of files.
  # We add a suid wrapper and a wrapper script to trick cups into calling the suid wrapper.
  # Note that a symlink to the suid wrapper alone wouldn't suffice, cups would complain
  # > File "/nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-cups-progs/lib/cups/backend/cups-pdf" has insecure permissions (0104554/uid=0/gid=20)

  # wrapper script that redirects calls to the suid wrapper
  cups-pdf-wrapper = pkgs.writeTextFile {
    name = "${pkgs.cups-pdf-to-pdf.name}-wrapper.sh";
    executable = true;
    destination = "/lib/cups/backend/cups-pdf";
    checkPhase = ''
      ${pkgs.stdenv.shellDryRun} "$target"
      ${lib.getExe pkgs.shellcheck} "$target"
    '';
    text = ''
      #! ${pkgs.runtimeShell}
      exec "${config.security.wrapperDir}/cups-pdf" "$@"
    '';
  };

  # wrapped cups-pdf package that uses the suid wrapper
  cups-pdf-wrapped = pkgs.buildEnv {
    name = "${pkgs.cups-pdf-to-pdf.name}-wrapped";
    # using the wrapper as first path ensures it is used
    paths = [ cups-pdf-wrapper pkgs.cups-pdf-to-pdf ];
    ignoreCollisions = true;
  };

  instanceSettings = name: {
    freeformType = with lib.types; nullOr (oneOf [ int str path package ]);
    # override defaults:
    # inject instance name into paths,
    # also avoid conflicts between user names and special dirs
    options.Out = lib.mkOption {
      type = with lib.types; nullOr singleLineStr;
      default = "/var/spool/cups-pdf-${name}/users/\${USER}";
      defaultText = "/var/spool/cups-pdf-{instance-name}/users/\${USER}";
      example = "\${HOME}/cups-pdf";
      description = lib.mdDoc ''
        output directory;
        `''${HOME}` will be expanded to the user's home directory,
        `''${USER}` will be expanded to the user name.
      '';
    };
    options.AnonDirName = lib.mkOption {
      type = with lib.types; nullOr singleLineStr;
      default = "/var/spool/cups-pdf-${name}/anonymous";
      defaultText = "/var/spool/cups-pdf-{instance-name}/anonymous";
      example = "/var/lib/cups-pdf";
      description = lib.mdDoc "path for anonymously created PDF files";
    };
    options.Spool = lib.mkOption {
      type = with lib.types; nullOr singleLineStr;
      default = "/var/spool/cups-pdf-${name}/spool";
      defaultText = "/var/spool/cups-pdf-{instance-name}/spool";
      example = "/var/lib/cups-pdf";
      description = lib.mdDoc "spool directory";
    };
    options.Anonuser = lib.mkOption {
      type = lib.types.singleLineStr;
      default = "root";
      description = lib.mdDoc ''
        User for anonymous PDF creation.
        An empty string disables this feature.
      '';
    };
    options.GhostScript = lib.mkOption {
      type = with lib.types; nullOr path;
      default = lib.getExe pkgs.ghostscript;
      defaultText = lib.literalExpression "lib.getExe pkgs.ghostscript";
      example = lib.literalExpression ''''${pkgs.ghostscript}/bin/ps2pdf'';
      description = lib.mdDoc "location of GhostScript binary";
    };
  };

  instanceConfig = { name, config, ... }: {
    options = {
      enable = (lib.mkEnableOption (lib.mdDoc "this cups-pdf instance")) // { default = true; };
      installPrinter = (lib.mkEnableOption (lib.mdDoc ''
        a CUPS printer queue for this instance.
        The queue will be named after the instance and will use the {file}`CUPS-PDF_opt.ppd` ppd file.
        If this is disabled, you need to add the queue yourself to use the instance
      '')) // { default = true; };
      confFileText = lib.mkOption {
        type = lib.types.lines;
        description = lib.mdDoc ''
          This will contain the contents of {file}`cups-pdf.conf` for this instance, derived from {option}`settings`.
          You can use this option to append text to the file.
        '';
      };
      settings = lib.mkOption {
        type = lib.types.submodule (instanceSettings name);
        default = {};
        example = {
          Out = "\${HOME}/cups-pdf";
          UserUMask = "0033";
        };
        description = lib.mdDoc ''
          Settings for a cups-pdf instance, see the descriptions in the template config file in the cups-pdf package.
          The key value pairs declared here will be translated into proper key value pairs for {file}`cups-pdf.conf`.
          Setting a value to `null` disables the option and removes it from the file.
        '';
      };
    };
    config.confFileText = lib.pipe config.settings [
      (lib.filterAttrs (key: value: value != null))
      (lib.mapAttrs (key: builtins.toString))
      (lib.mapAttrsToList (key: value: "${key} ${value}\n"))
      lib.concatStrings
    ];
  };

  cupsPdfCfg = config.services.printing.cups-pdf;

  copyConfigFileCmds = lib.pipe cupsPdfCfg.instances [
    (lib.filterAttrs (name: lib.getAttr "enable"))
    (lib.mapAttrs (name: lib.getAttr "confFileText"))
    (lib.mapAttrs (name: pkgs.writeText "cups-pdf-${name}.conf"))
    (lib.mapAttrsToList (name: confFile: "ln --symbolic --no-target-directory ${confFile} /var/lib/cups/cups-pdf-${name}.conf\n"))
    lib.concatStrings
  ];

  printerSettings = lib.pipe cupsPdfCfg.instances [
    (lib.filterAttrs (name: lib.getAttr "enable"))
    (lib.filterAttrs (name: lib.getAttr "installPrinter"))
    (lib.mapAttrsToList (name: instance: (lib.mapAttrs (key: lib.mkDefault) {
      inherit name;
      model = "CUPS-PDF_opt.ppd";
      deviceUri = "cups-pdf:/${name}";
      description = "virtual printer for cups-pdf instance ${name}";
      location = instance.settings.Out;
    })))
  ];

in

{

  options.services.printing.cups-pdf = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      the cups-pdf virtual pdf printer backend.
      By default, this will install a single printer `pdf`.
      but this can be changed/extended with {option}`services.printing.cups-pdf.instances`
    '');
    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule instanceConfig);
      default.pdf = {};
      example.pdf.settings = {
        Out = "\${HOME}/cups-pdf";
        UserUMask = "0033";
      };
      description = lib.mdDoc ''
        Permits to raise one or more cups-pdf instances.
        Each instance is named by an attribute name, and the attribute's values control the instance' configuration.
      '';
    };
  };

  config = lib.mkIf cupsPdfCfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [ cups-pdf-wrapped ];
    hardware.printers.ensurePrinters = printerSettings;
    # the cups module will install the default config file,
    # but we don't need it and it would confuse cups-pdf
    systemd.services.cups.preStart = lib.mkAfter ''
      rm -f /var/lib/cups/cups-pdf.conf
      ${copyConfigFileCmds}
    '';
    security.wrappers.cups-pdf = {
      group = "lp";
      owner = "root";
      permissions = "+r,ug+x";
      setuid = true;
      source = "${pkgs.cups-pdf-to-pdf}/lib/cups/backend/cups-pdf";
    };
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
