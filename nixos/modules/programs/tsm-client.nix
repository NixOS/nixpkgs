{ config, lib, options, pkgs, ... }:  # XXX migration code for freeform settings: `options` can be removed in 2025
let optionsGlobal = options; in

let

  inherit (lib.attrsets) attrNames attrValues mapAttrsToList removeAttrs;
  inherit (lib.lists) all allUnique concatLists elem isList map;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  inherit (lib.strings) concatLines match optionalString toLower;
  inherit (lib.trivial) isInt;
  inherit (lib.types) addCheck attrsOf coercedTo either enum int lines listOf nonEmptyStr nullOr oneOf path port singleLineStr strMatching submodule;

  scalarType =
    # see the option's description below for the
    # handling/transformation of each possible type
    oneOf [ (enum [ true null ]) int path singleLineStr ];

  # TSM rejects servername strings longer than 64 chars.
  servernameType = strMatching "[^[:space:]]{1,64}";

  serverOptions = { name, config, ... }: {
    freeformType = attrsOf (either scalarType (listOf scalarType));
    # Client system-options file directives are explained here:
    # https://www.ibm.com/docs/en/storage-protect/8.1.20?topic=commands-processing-options
    options.servername = mkOption {
      type = servernameType;
      default = name;
      example = "mainTsmServer";
      description = lib.mdDoc ''
        Local name of the IBM TSM server,
        must not contain space or more than 64 chars.
      '';
    };
    options.tcpserveraddress = mkOption {
      type = nonEmptyStr;
      example = "tsmserver.company.com";
      description = lib.mdDoc ''
        Host/domain name or IP address of the IBM TSM server.
      '';
    };
    options.tcpport = mkOption {
      type = addCheck port (p: p<=32767);
      default = 1500;  # official default
      description = lib.mdDoc ''
        TCP port of the IBM TSM server.
        TSM does not support ports above 32767.
      '';
    };
    options.nodename = mkOption {
      type = nonEmptyStr;
      example = "MY-TSM-NODE";
      description = lib.mdDoc ''
        Target node name on the IBM TSM server.
      '';
    };
    options.genPasswd = mkEnableOption (lib.mdDoc ''
      automatic client password generation.
      This option does *not* cause a line in
      {file}`dsm.sys` by itself, but generates a
      corresponding `passwordaccess` directive.
      The password will be stored in the directory
      given by the option {option}`passworddir`.
      *Caution*:
      If this option is enabled and the server forces
      to renew the password (e.g. on first connection),
      a random password will be generated and stored
    '');
    options.passwordaccess = mkOption {
      type = enum [ "generate" "prompt" ];
      visible = false;
    };
    options.passworddir = mkOption {
      type = nullOr path;
      default = null;
      example = "/home/alice/tsm-password";
      description = lib.mdDoc ''
        Directory that holds the TSM
        node's password information.
      '';
    };
    options.inclexcl = mkOption {
      type = coercedTo lines
        (pkgs.writeText "inclexcl.dsm.sys")
        (nullOr path);
      default = null;
      example = ''
        exclude.dir     /nix/store
        include.encrypt /home/.../*
      '';
      description = lib.mdDoc ''
        Text lines with `include.*` and `exclude.*` directives
        to be used when sending files to the IBM TSM server,
        or an absolute path pointing to a file with such lines.
      '';
    };
    config.commmethod = mkDefault "v6tcpip";  # uses v4 or v6, based on dns lookup result
    config.passwordaccess = if config.genPasswd then "generate" else "prompt";
    # XXX migration code for freeform settings, these can be removed in 2025:
    options.warnings = optionsGlobal.warnings;
    options.assertions = optionsGlobal.assertions;
    imports = let inherit (lib.modules) mkRemovedOptionModule mkRenamedOptionModule; in [
      (mkRemovedOptionModule [ "extraConfig" ] "Please just add options directly to the server attribute set, cf. the description of `programs.tsmClient.servers`.")
      (mkRemovedOptionModule [ "text" ] "Please just add options directly to the server attribute set, cf. the description of `programs.tsmClient.servers`.")
      (mkRenamedOptionModule [ "name" ] [ "servername" ])
      (mkRenamedOptionModule [ "server" ] [ "tcpserveraddress" ])
      (mkRenamedOptionModule [ "port" ] [ "tcpport" ])
      (mkRenamedOptionModule [ "node" ] [ "nodename" ])
      (mkRenamedOptionModule [ "passwdDir" ] [ "passworddir" ])
      (mkRenamedOptionModule [ "includeExclude" ] [ "inclexcl" ])
    ];
  };

  options.programs.tsmClient = {
    enable = mkEnableOption (lib.mdDoc ''
      IBM Storage Protect (Tivoli Storage Manager, TSM)
      client command line applications with a
      client system-options file "dsm.sys"
    '');
    servers = mkOption {
      type = attrsOf (submodule serverOptions);
      default = {};
      example.mainTsmServer = {
        tcpserveraddress = "tsmserver.company.com";
        nodename = "MY-TSM-NODE";
        compression = "yes";
      };
      description = lib.mdDoc ''
        Server definitions ("stanzas")
        for the client system-options file.
        The name of each entry will be used for
        the internal `servername` by default.
        Each attribute will be transformed into a line
        with a key-value pair within the server's stanza.
        Integers as values will be
        canonically turned into strings.
        The boolean value `true` will be turned
        into a line with just the attribute's name.
        The value `null` will not generate a line.
        A list as values generates an entry for
        each value, according to the rules above.
      '';
    };
    defaultServername = mkOption {
      type = nullOr servernameType;
      default = null;
      example = "mainTsmServer";
      description = lib.mdDoc ''
        If multiple server stanzas are declared with
        {option}`programs.tsmClient.servers`,
        this option may be used to name a default
        server stanza that IBM TSM uses in the absence of
        a user-defined {file}`dsm.opt` file.
        This option translates to a
        `defaultserver` configuration line.
      '';
    };
    dsmSysText = mkOption {
      type = lines;
      readOnly = true;
      description = lib.mdDoc ''
        This configuration key contains the effective text
        of the client system-options file "dsm.sys".
        It should not be changed, but may be
        used to feed the configuration into other
        TSM-depending packages used on the system.
      '';
    };
    package = mkPackageOption pkgs "tsm-client" {
      example = "tsm-client-withGui";
      extraDescription = ''
        It will be used with `.override`
        to add paths to the client system-options file.
      '';
    };
    wrappedPackage = mkPackageOption pkgs "tsm-client" {
      default = null;
      extraDescription = ''
        This option is to provide the effective derivation,
        wrapped with the path to the
        client system-options file "dsm.sys".
        It should not be changed, but exists
        for other modules that want to call TSM executables.
      '';
    } // { readOnly = true; };
  };

  cfg = config.programs.tsmClient;
  servernames = map (s: s.servername) (attrValues cfg.servers);

  assertions =
    [
      {
        assertion = allUnique (map toLower servernames);
        message = ''
          TSM server names
          (option `programs.tsmClient.servers`)
          contain duplicate name
          (note that server names are case insensitive).
        '';
      }
      {
        assertion = (cfg.defaultServername!=null)->(elem cfg.defaultServername servernames);
        message = ''
          TSM default server name
          `programs.tsmClient.defaultServername="${cfg.defaultServername}"`
          not found in server names in
          `programs.tsmClient.servers`.
        '';
      }
    ] ++ (mapAttrsToList (name: serverCfg: {
      assertion = all (key: null != match "[^[:space:]]+" key) (attrNames serverCfg);
      message = ''
        TSM server setting names in
        `programs.tsmClient.servers.${name}.*`
        contain spaces, but that's not allowed.
      '';
    }) cfg.servers) ++ (mapAttrsToList (name: serverCfg: {
      assertion = allUnique (map toLower (attrNames serverCfg));
      message = ''
        TSM server setting names in
        `programs.tsmClient.servers.${name}.*`
        contain duplicate names
        (note that setting names are case insensitive).
      '';
    }) cfg.servers)
    # XXX migration code for freeform settings, this can be removed in 2025:
    ++ (enrichMigrationInfos "assertions" (addText: { assertion, message }: { inherit assertion; message = addText message; }));

  makeDsmSysLines = key: value:
    # Turn a key-value pair from the server options attrset
    # into zero (value==null), one (scalar value) or
    # more (value is list) configuration stanza lines.
    if isList value then map (makeDsmSysLines key) value else  # recurse into list
    if value == null then [ ] else  # skip `null` value
    [ ("  ${key}${
      if value == true then "" else  # just output key if value is `true`
      if isInt value then "  ${builtins.toString value}" else
      if path.check value then "  \"${value}\"" else  # enclose path in ".."
      if singleLineStr.check value then "  ${value}" else
      throw "assertion failed: cannot convert type"  # should never happen
    }") ];

  makeDsmSysStanza = {servername, ... }@serverCfg:
    let
      # drop special values that should not go into server config block
      attrs = removeAttrs serverCfg [ "servername" "genPasswd"
        # XXX migration code for freeform settings, these can be removed in 2025:
        "assertions" "warnings"
        "extraConfig" "text"
        "name" "server" "port" "node" "passwdDir" "includeExclude"
      ];
    in
      ''
        servername  ${servername}
        ${concatLines (concatLists (mapAttrsToList makeDsmSysLines attrs))}
      '';

  dsmSysText = ''
    ****  IBM Storage Protect (Tivoli Storage Manager)
    ****  client system-options file "dsm.sys".
    ****  Do not edit!
    ****  This file is generated by NixOS configuration.

    ${optionalString (cfg.defaultServername!=null) "defaultserver  ${cfg.defaultServername}"}

    ${concatLines (map makeDsmSysStanza (attrValues cfg.servers))}
  '';

  # XXX migration code for freeform settings, this can be removed in 2025:
  enrichMigrationInfos = what: how: concatLists (
    mapAttrsToList
    (name: serverCfg: map (how (text: "In `programs.tsmClient.servers.${name}`: ${text}")) serverCfg."${what}")
    cfg.servers
  );

in

{

  inherit options;

  config = mkIf cfg.enable {
    inherit assertions;
    programs.tsmClient.dsmSysText = dsmSysText;
    programs.tsmClient.wrappedPackage = cfg.package.override rec {
      dsmSysCli = pkgs.writeText "dsm.sys" cfg.dsmSysText;
      dsmSysApi = dsmSysCli;
    };
    environment.systemPackages = [ cfg.wrappedPackage ];
    # XXX migration code for freeform settings, this can be removed in 2025:
    warnings = enrichMigrationInfos "warnings" (addText: addText);
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
