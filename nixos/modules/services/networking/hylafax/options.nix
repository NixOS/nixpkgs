{ config, lib, pkgs, ... }:

let

  inherit (lib.options) literalExample mkEnableOption mkOption;
  inherit (lib.types) bool enum int lines loaOf nullOr path str submodule;
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

  str1 = lib.types.addCheck str (s: s!="");  # non-empty string
  int1 = lib.types.addCheck int (i: i>0);  # positive integer

  configAttrType =
    # Options in HylaFAX configuration files can be
    # booleans, strings, integers, or list thereof
    # representing multiple config directives with the same key.
    # This type definition resolves all
    # those types into a list of strings.
    let
      inherit (lib.types) attrsOf coercedTo listOf;
      innerType = coercedTo bool (x: if x then "Yes" else "No")
        (coercedTo int (toString) str);
    in
      attrsOf (coercedTo innerType lib.singleton (listOf innerType));

  cfg = config.services.hylafax;

  modemConfigOptions = { name, config, ... }: {
    options = {
      name = mkOption {
        type = str1;
        example = "ttyS1";
        description = ''
          Name of modem device,
          will be searched for in <filename>/dev</filename>.
        '';
      };
      type = mkOption {
        type = str1;
        example = "cirrus";
        description = ''
          Name of modem configuration file,
          will be searched for in <filename>config</filename>
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
        description = ''
          Attribute set of values for the given modem.
          ${commonDescr}
          Options defined here override options in
          <option>commonModemConfig</option> for this modem.
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
        (mkIfDefault noWrapper ''${pkgs.coreutils}/bin/false'')
        (mkIfDefault (!noWrapper) ''${wrapperDir}/${program}'')
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

    enable = mkEnableOption ''HylaFAX server'';

    autostart = mkOption {
      type = bool;
      default = true;
      example = false;
      description = ''
        Autostart the HylaFAX queue manager at system start.
        If this is <literal>false</literal>, the queue manager
        will still be started if there are pending
        jobs or if a user tries to connect to it.
      '';
    };

    countryCode = mkOption {
      type = nullOr str1;
      default = null;
      example = "49";
      description = ''Country code for server and all modems.'';
    };

    areaCode = mkOption {
      type = nullOr str1;
      default = null;
      example = "30";
      description = ''Area code for server and all modems.'';
    };

    longDistancePrefix = mkOption {
      type = nullOr str;
      default = null;
      example = "0";
      description = ''Long distance prefix for server and all modems.'';
    };

    internationalPrefix = mkOption {
      type = nullOr str;
      default = null;
      example = "00";
      description = ''International prefix for server and all modems.'';
    };

    spoolAreaPath = mkOption {
      type = path;
      default = "/var/spool/fax";
      description = ''
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
        <literal>
          environment.etc."hosts.hfaxd" = {
            mode = "0600";
            user = "uucp";
            text = ".*";
          };
        </literal>
        Note that host-based access can be controlled with
        <option>config.systemd.sockets.hylafax-hfaxd.listenStreams</option>;
        by default, only 127.0.0.1 is permitted to connect.
      '';
    };

    sendmailPath = mkOption {
      type = path;
      example = literalExample "''${pkgs.postfix}/bin/sendmail";
      # '' ;  # fix vim
      description = ''
        Path to <filename>sendmail</filename> program.
        The default uses the local sendmail wrapper
        (see <option>config.services.mail.sendmailSetuidWrapper</option>),
        otherwise the <filename>false</filename>
        binary to cause an error if used.
      '';
    };

    hfaxdConfig = mkOption {
      type = configAttrType;
      example.RecvqProtection = "0400";
      description = ''
        Attribute set of lines for the global
        hfaxd config file <filename>etc/hfaxd.conf</filename>.
        ${commonDescr}
      '';
    };

    faxqConfig = mkOption {
      type = configAttrType;
      example = {
        InternationalPrefix = "00";
        LongDistancePrefix = "0";
      };
      description = ''
        Attribute set of lines for the global
        faxq config file <filename>etc/config</filename>.
        ${commonDescr}
      '';
    };

    commonModemConfig = mkOption {
      type = configAttrType;
      example = {
        InternationalPrefix = "00";
        LongDistancePrefix = "0";
      };
      description = ''
        Attribute set of default values for
        modem config files <filename>etc/config.*</filename>.
        ${commonDescr}
        Think twice before changing
        paths of fax-processing scripts.
      '';
    };

    modems = mkOption {
      type = loaOf (submodule [ modemConfigOptions ]);
      default = {};
      example.ttyS1 = {
        type = "cirrus";
        config = {
          FAXNumber = "123456";
          LocalIdentifier = "Smith";
        };
      };
      description = ''
        Description of installed modems.
        At least on modem must be defined
        to enable the HylaFAX server.
      '';
    };

    spoolExtraInit = mkOption {
      type = lines;
      default = "";
      example = ''chmod 0755 .  # everyone may read my faxes'';
      description = ''
        Additional shell code that is executed within the
        spooling area directory right after its setup.
      '';
    };

    faxcron.enable.spoolInit = mkEnableOption ''
      Purge old files from the spooling area with
      <filename>faxcron</filename>
      each time the spooling area is initialized.
    '';
    faxcron.enable.frequency = mkOption {
      type = nullOr str1;
      default = null;
      example = "daily";
      description = ''
        Purge old files from the spooling area with
        <filename>faxcron</filename> with the given frequency
        (see systemd.time(7)).
      '';
    };
    faxcron.infoDays = mkOption {
      type = int1;
      default = 30;
      description = ''
        Set the expiration time for data in the
        remote machine information directory in days.
      '';
    };
    faxcron.logDays = mkOption {
      type = int1;
      default = 30;
      description = ''
        Set the expiration time for
        session trace log files in days.
      '';
    };
    faxcron.rcvDays = mkOption {
      type = int1;
      default = 7;
      description = ''
        Set the expiration time for files in
        the received facsimile queue in days.
      '';
    };

    faxqclean.enable.spoolInit = mkEnableOption ''
      Purge old files from the spooling area with
      <filename>faxqclean</filename>
      each time the spooling area is initialized.
    '';
    faxqclean.enable.frequency = mkOption {
      type = nullOr str1;
      default = null;
      example = "daily";
      description = ''
        Purge old files from the spooling area with
        <filename>faxcron</filename> with the given frequency
        (see systemd.time(7)).
      '';
    };
    faxqclean.archiving = mkOption {
      type = enum [ "never" "as-flagged" "always" ];
      default = "as-flagged";
      example = "always";
      description = ''
        Enable or suppress job archiving:
        <literal>never</literal> disables job archiving,
        <literal>as-flagged</literal> archives jobs that
        have been flagged for archiving by sendfax,
        <literal>always</literal> forces archiving of all jobs.
        See also sendfax(1) and faxqclean(8).
      '';
    };
    faxqclean.doneqMinutes = mkOption {
      type = int1;
      default = 15;
      example = literalExample ''24*60'';
      description = ''
        Set the job
        age threshold (in minutes) that controls how long
        jobs may reside in the doneq directory.
      '';
    };
    faxqclean.docqMinutes = mkOption {
      type = int1;
      default = 60;
      example = literalExample ''24*60'';
      description = ''
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
