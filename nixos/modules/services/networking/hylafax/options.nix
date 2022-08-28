{ config, lib, pkgs, ... }:

let

  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.types) bool enum ints lines attrsOf nonEmptyStr nullOr path str submodule;
  inherit (lib.modules) mkDefault mkIf mkMerge;

  commonDescr = ''
    Values can be either strings or integers
    (which will be added to the config file verbatimly)
    or lists thereof
    (which will be translated to multiple
    lines with the same configuration key).
    Boolean values are translated to "Yes" or "No".
    The default contains some reasonable
    configuration to yield an operational system.
  '';

  configAttrType =
    # Options in HylaFAX configuration files can be
    # booleans, strings, integers, or list thereof
    # representing multiple config directives with the same key.
    # This type definition resolves all
    # those types into a list of strings.
    let
      inherit (lib.types) attrsOf coercedTo int listOf;
      innerType = coercedTo bool (x: if x then "Yes" else "No")
        (coercedTo int (toString) str);
    in
      attrsOf (coercedTo innerType lib.singleton (listOf innerType));

  cfg = config.services.hylafax;

  modemConfigOptions = { name, config, ... }: {
    options = {
      name = mkOption {
        type = nonEmptyStr;
        example = "ttyS1";
        description = lib.mdDoc ''
          Name of modem device,
          will be searched for in {file}`/dev`.
        '';
      };
      type = mkOption {
        type = nonEmptyStr;
        example = "cirrus";
        description = lib.mdDoc ''
          Name of modem configuration file,
          will be searched for in {file}`config`
          in the spooling area directory.
        '';
      };
      config = mkOption {
        type = configAttrType;
        example = {
          AreaCode = "49";
          LocalCode = "30";
          FAXNumber = "123456";
          LocalIdentifier = "LostInBerlin";
        };
        description = lib.mdDoc ''
          Attribute set of values for the given modem.
          ${commonDescr}
          Options defined here override options in
          {option}`commonModemConfig` for this modem.
        '';
      };
    };
    config.name = mkDefault name;
    config.config.Include = [ "config/${config.type}" ];
  };

  defaultConfig =
    let
      inherit (config.security) wrapperDir;
      inherit (config.services.mail.sendmailSetuidWrapper) program;
      mkIfDefault = cond: value: mkIf cond (mkDefault value);
      noWrapper = config.services.mail.sendmailSetuidWrapper==null;
      # If a sendmail setuid wrapper exists,
      # we add the path to the default configuration file.
      # Otherwise, we use `false` to provoke
      # an error if hylafax tries to use it.
      c.sendmailPath = mkMerge [
        (mkIfDefault noWrapper "${pkgs.coreutils}/bin/false")
        (mkIfDefault (!noWrapper) "${wrapperDir}/${program}")
      ];
      importDefaultConfig = file:
        lib.attrsets.mapAttrs
        (lib.trivial.const mkDefault)
        (import file { inherit pkgs; });
      c.commonModemConfig = importDefaultConfig ./modem-default.nix;
      c.faxqConfig = importDefaultConfig ./faxq-default.nix;
      c.hfaxdConfig = importDefaultConfig ./hfaxd-default.nix;
    in
      c;

  localConfig =
    let
      c.hfaxdConfig.UserAccessFile = cfg.userAccessFile;
      c.faxqConfig = lib.attrsets.mapAttrs
        (lib.trivial.const (v: mkIf (v!=null) v))
        {
          AreaCode = cfg.areaCode;
          CountryCode = cfg.countryCode;
          LongDistancePrefix = cfg.longDistancePrefix;
          InternationalPrefix = cfg.internationalPrefix;
        };
      c.commonModemConfig = c.faxqConfig;
    in
      c;

in


{


  options.services.hylafax = {

    enable = mkEnableOption (lib.mdDoc "HylaFAX server");

    autostart = mkOption {
      type = bool;
      default = true;
      example = false;
      description = lib.mdDoc ''
        Autostart the HylaFAX queue manager at system start.
        If this is `false`, the queue manager
        will still be started if there are pending
        jobs or if a user tries to connect to it.
      '';
    };

    countryCode = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
      example = "49";
      description = lib.mdDoc "Country code for server and all modems.";
    };

    areaCode = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
      example = "30";
      description = lib.mdDoc "Area code for server and all modems.";
    };

    longDistancePrefix = mkOption {
      type = nullOr str;
      default = null;
      example = "0";
      description = lib.mdDoc "Long distance prefix for server and all modems.";
    };

    internationalPrefix = mkOption {
      type = nullOr str;
      default = null;
      example = "00";
      description = lib.mdDoc "International prefix for server and all modems.";
    };

    spoolAreaPath = mkOption {
      type = path;
      default = "/var/spool/fax";
      description = lib.mdDoc ''
        The spooling area will be created/maintained
        at the location given here.
      '';
    };

    userAccessFile = mkOption {
      type = path;
      default = "/etc/hosts.hfaxd";
      description = ''
        The <filename>hosts.hfaxd</filename>
        file entry in the spooling area
        will be symlinked to the location given here.
        This file must exist and be
        readable only by the <literal>uucp</literal> user.
        See hosts.hfaxd(5) for details.
        This configuration permits access for all users:
        <programlisting>
          environment.etc."hosts.hfaxd" = {
            mode = "0600";
            user = "uucp";
            text = ".*";
          };
        </programlisting>
        Note that host-based access can be controlled with
        <option>config.systemd.sockets.hylafax-hfaxd.listenStreams</option>;
        by default, only 127.0.0.1 is permitted to connect.
      '';
    };

    sendmailPath = mkOption {
      type = path;
      example = literalExpression ''"''${pkgs.postfix}/bin/sendmail"'';
      # '' ;  # fix vim
      description = lib.mdDoc ''
        Path to {file}`sendmail` program.
        The default uses the local sendmail wrapper
        (see {option}`config.services.mail.sendmailSetuidWrapper`),
        otherwise the {file}`false`
        binary to cause an error if used.
      '';
    };

    hfaxdConfig = mkOption {
      type = configAttrType;
      example.RecvqProtection = "0400";
      description = lib.mdDoc ''
        Attribute set of lines for the global
        hfaxd config file {file}`etc/hfaxd.conf`.
        ${commonDescr}
      '';
    };

    faxqConfig = mkOption {
      type = configAttrType;
      example = {
        InternationalPrefix = "00";
        LongDistancePrefix = "0";
      };
      description = lib.mdDoc ''
        Attribute set of lines for the global
        faxq config file {file}`etc/config`.
        ${commonDescr}
      '';
    };

    commonModemConfig = mkOption {
      type = configAttrType;
      example = {
        InternationalPrefix = "00";
        LongDistancePrefix = "0";
      };
      description = lib.mdDoc ''
        Attribute set of default values for
        modem config files {file}`etc/config.*`.
        ${commonDescr}
        Think twice before changing
        paths of fax-processing scripts.
      '';
    };

    modems = mkOption {
      type = attrsOf (submodule [ modemConfigOptions ]);
      default = {};
      example.ttyS1 = {
        type = "cirrus";
        config = {
          FAXNumber = "123456";
          LocalIdentifier = "Smith";
        };
      };
      description = lib.mdDoc ''
        Description of installed modems.
        At least on modem must be defined
        to enable the HylaFAX server.
      '';
    };

    spoolExtraInit = mkOption {
      type = lines;
      default = "";
      example = "chmod 0755 .  # everyone may read my faxes";
      description = lib.mdDoc ''
        Additional shell code that is executed within the
        spooling area directory right after its setup.
      '';
    };

    faxcron.enable.spoolInit = mkEnableOption (lib.mdDoc ''
      Purge old files from the spooling area with
      {file}`faxcron`
      each time the spooling area is initialized.
    '');
    faxcron.enable.frequency = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
      example = "daily";
      description = lib.mdDoc ''
        Purge old files from the spooling area with
        {file}`faxcron` with the given frequency
        (see systemd.time(7)).
      '';
    };
    faxcron.infoDays = mkOption {
      type = ints.positive;
      default = 30;
      description = lib.mdDoc ''
        Set the expiration time for data in the
        remote machine information directory in days.
      '';
    };
    faxcron.logDays = mkOption {
      type = ints.positive;
      default = 30;
      description = lib.mdDoc ''
        Set the expiration time for
        session trace log files in days.
      '';
    };
    faxcron.rcvDays = mkOption {
      type = ints.positive;
      default = 7;
      description = lib.mdDoc ''
        Set the expiration time for files in
        the received facsimile queue in days.
      '';
    };

    faxqclean.enable.spoolInit = mkEnableOption (lib.mdDoc ''
      Purge old files from the spooling area with
      {file}`faxqclean`
      each time the spooling area is initialized.
    '');
    faxqclean.enable.frequency = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
      example = "daily";
      description = lib.mdDoc ''
        Purge old files from the spooling area with
        {file}`faxcron` with the given frequency
        (see systemd.time(7)).
      '';
    };
    faxqclean.archiving = mkOption {
      type = enum [ "never" "as-flagged" "always" ];
      default = "as-flagged";
      example = "always";
      description = lib.mdDoc ''
        Enable or suppress job archiving:
        `never` disables job archiving,
        `as-flagged` archives jobs that
        have been flagged for archiving by sendfax,
        `always` forces archiving of all jobs.
        See also sendfax(1) and faxqclean(8).
      '';
    };
    faxqclean.doneqMinutes = mkOption {
      type = ints.positive;
      default = 15;
      example = literalExpression "24*60";
      description = lib.mdDoc ''
        Set the job
        age threshold (in minutes) that controls how long
        jobs may reside in the doneq directory.
      '';
    };
    faxqclean.docqMinutes = mkOption {
      type = ints.positive;
      default = 60;
      example = literalExpression "24*60";
      description = lib.mdDoc ''
        Set the document
        age threshold (in minutes) that controls how long
        unreferenced files may reside in the docq directory.
      '';
    };

  };


  config.services.hylafax =
    mkIf
    (config.services.hylafax.enable)
    (mkMerge [ defaultConfig localConfig ])
  ;

}
