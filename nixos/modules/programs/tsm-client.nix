{
  config,
  lib,
  options,
  pkgs,
  ...
}: # XXX migration code for freeform settings: `options` can be removed in 2025
let
  optionsGlobal = options;
in

let
  scalarType =
    # see the option's description below for the
    # handling/transformation of each possible type
    lib.types.oneOf [
      (lib.types.enum [
        true
        null
      ])
      lib.types.int
      lib.types.path
      lib.types.singleLineStr
    ];

  # TSM rejects servername strings longer than 64 chars.
  servernameType = lib.strMatching "[^[:space:]]{1,64}";

  serverOptions =
    { name, config, ... }:
    {
      freeformType = lib.attrsOf (lib.either scalarType (lib.listOf scalarType));
      # Client system-options file directives are explained here:
      # https://www.ibm.com/docs/en/storage-protect/8.1.25?topic=commands-processing-options
      options.servername = lib.mkOption {
        type = servernameType;
        default = name;
        example = "mainTsmServer";
        description = ''
          Local name of the IBM TSM server,
          must not contain space or more than 64 chars.
        '';
      };
      options.tcpserveraddress = lib.mkOption {
        type = lib.types.nonEmptyStr;
        example = "tsmserver.company.com";
        description = ''
          Host/domain name or IP address of the IBM TSM server.
        '';
      };
      options.tcpport = lib.mkOption {
        type = lib.types.addCheck lib.types.port (p: p <= 32767);
        default = 1500; # official default
        description = ''
          TCP port of the IBM TSM server.
          TSM does not support ports above 32767.
        '';
      };
      options.nodename = lib.mkOption {
        type = lib.types.nonEmptyStr;
        example = "MY-TSM-NODE";
        description = ''
          Target node name on the IBM TSM server.
        '';
      };
      options.genPasswd = lib.mkEnableOption ''
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
      '';
      options.passwordaccess = lib.mkOption {
        type = lib.types.enum [
          "generate"
          "prompt"
        ];
        visible = false;
      };
      options.passworddir = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/home/alice/tsm-password";
        description = ''
          Directory that holds the TSM
          node's password information.
        '';
      };
      options.inclexcl = lib.mkOption {
        type = lib.types.coercedTo lib.types.lines (pkgs.writeText "inclexcl.dsm.sys") (lib.types.nullOr lib.types.path);
        default = null;
        example = ''
          exclude.dir     /nix/store
          include.encrypt /home/.../*
        '';
        description = ''
          Text lines with `include.*` and `exclude.*` directives
          to be used when sending files to the IBM TSM server,
          or an absolute path pointing to a file with such lines.
        '';
      };
      config.commmethod = lib.mkDefault "v6tcpip"; # uses v4 or v6, based on dns lookup result
      config.passwordaccess = if config.genPasswd then "generate" else "prompt";
      # XXX migration code for freeform settings, these can be removed in 2025:
      options.warnings = optionsGlobal.warnings;
      options.assertions = optionsGlobal.assertions;
      imports =
        [
          (lib.mkRemovedOptionModule [ "extraConfig" ]
            "Please just add options directly to the server attribute set, cf. the description of `programs.tsmClient.servers`."
          )
          (lib.mkRemovedOptionModule [ "text" ]
            "Please just add options directly to the server attribute set, cf. the description of `programs.tsmClient.servers`."
          )
          (lib.mkRenamedOptionModule [ "name" ] [ "servername" ])
          (lib.mkRenamedOptionModule [ "server" ] [ "tcpserveraddress" ])
          (lib.mkRenamedOptionModule [ "port" ] [ "tcpport" ])
          (lib.mkRenamedOptionModule [ "node" ] [ "nodename" ])
          (lib.mkRenamedOptionModule [ "passwdDir" ] [ "passworddir" ])
          (lib.mkRenamedOptionModule [ "includeExclude" ] [ "inclexcl" ])
        ];
    };

  options.programs.tsmClient = {
    enable = lib.mkEnableOption ''
      IBM Storage Protect (Tivoli Storage Manager, TSM)
      client command line applications with a
      client system-options file "dsm.sys"
    '';
    servers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule serverOptions);
      default = { };
      example.mainTsmServer = {
        tcpserveraddress = "tsmserver.company.com";
        nodename = "MY-TSM-NODE";
        compression = "yes";
      };
      description = ''
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
    defaultServername = lib.mkOption {
      type = lib.types.nullOr servernameType;
      default = null;
      example = "mainTsmServer";
      description = ''
        If multiple server stanzas are declared with
        {option}`programs.tsmClient.servers`,
        this option may be used to name a default
        server stanza that IBM TSM uses in the absence of
        a user-defined {file}`dsm.opt` file.
        This option translates to a
        `defaultserver` configuration line.
      '';
    };
    dsmSysText = lib.mkOption {
      type = lib.types.lines;
      readOnly = true;
      description = ''
        This configuration key contains the effective text
        of the client system-options file "dsm.sys".
        It should not be changed, but may be
        used to feed the configuration into other
        TSM-depending packages used on the system.
      '';
    };
    package = lib.mkPackageOption pkgs "tsm-client" {
      example = "tsm-client-withGui";
      extraDescription = ''
        It will be used with `.override`
        to add paths to the client system-options file.
      '';
    };
    wrappedPackage =
      lib.mkPackageOption pkgs "tsm-client" {
        default = null;
        extraDescription = ''
          This option is to provide the effective derivation,
          wrapped with the path to the
          client system-options file "dsm.sys".
          It should not be changed, but exists
          for other modules that want to call TSM executables.
        '';
      }
      // {
        readOnly = true;
      };
  };

  cfg = config.programs.tsmClient;
  servernames = map (s: s.servername) (lib.attrValues cfg.servers);

  assertions =
    [
      {
        assertion = lib.allUnique (map lib.toLower servernames);
        message = ''
          TSM server names
          (option `programs.tsmClient.servers`)
          contain duplicate name
          (note that server names are case insensitive).
        '';
      }
      {
        assertion = (cfg.defaultServername != null) -> (lib.elem cfg.defaultServername servernames);
        message = ''
          TSM default server name
          `programs.tsmClient.defaultServername="${cfg.defaultServername}"`
          not found in server names in
          `programs.tsmClient.servers`.
        '';
      }
    ]
    ++ (lib.mapAttrsToList (name: serverCfg: {
      assertion = lib.all (key: null != lib.match "[^[:space:]]+" key) (lib.attrNames serverCfg);
      message = ''
        TSM server setting names in
        `programs.tsmClient.servers.${name}.*`
        contain spaces, but that's not allowed.
      '';
    }) cfg.servers)
    ++ (lib.mapAttrsToList (name: serverCfg: {
      assertion = lib.allUnique (map lib.toLower (lib.attrNames serverCfg));
      message = ''
        TSM server setting names in
        `programs.tsmClient.servers.${name}.*`
        contain duplicate names
        (note that setting names are case insensitive).
      '';
    }) cfg.servers)
    # XXX migration code for freeform settings, this can be removed in 2025:
    ++ (enrichMigrationInfos "assertions" (
      addText:
      { assertion, message }:
      {
        inherit assertion;
        message = addText message;
      }
    ));

  makeDsmSysLines =
    key: value:
    # Turn a key-value pair from the server options attrset
    # into zero (value==null), one (scalar value) or
    # more (value is list) configuration stanza lines.
    if lib.isList value then
      lib.concatMap (makeDsmSysLines key) value
    # recurse into list
    else if value == null then
      [ ]
    # skip `null` value
    else
      [
        (
          "  ${key}${
              if value == true then
                ""
              # just output key if value is `true`
              else if lib.isInt value then
                "  ${builtins.toString value}"
              else if lib.path.check value then
                "  \"${value}\""
              # enclose path in ".."
              else if lib.singleLineStr.check value then
                "  ${value}"
              else
                throw "assertion failed: cannot convert type" # should never happen
            }"
        )
      ];

  makeDsmSysStanza =
    { servername, ... }@serverCfg:
    let
      # drop special values that should not go into server config block
      attrs = removeAttrs serverCfg [
        "servername"
        "genPasswd"
        # XXX migration code for freeform settings, these can be removed in 2025:
        "assertions"
        "warnings"
        "extraConfig"
        "text"
        "name"
        "server"
        "port"
        "node"
        "passwdDir"
        "includeExclude"
      ];
    in
    ''
      servername  ${servername}
      ${lib.concatLines (lib.concatLists (lib.mapAttrsToList makeDsmSysLines attrs))}
    '';

  dsmSysText = ''
    ****  IBM Storage Protect (Tivoli Storage Manager)
    ****  client system-options file "dsm.sys".
    ****  Do not edit!
    ****  This file is generated by NixOS configuration.

    ${lib.optionalString (cfg.defaultServername != null) "defaultserver  ${cfg.defaultServername}"}

    ${lib.concatLines (map makeDsmSysStanza (lib.attrValues cfg.servers))}
  '';

  # XXX migration code for freeform settings, this can be removed in 2025:
  enrichMigrationInfos =
    what: how:
    lib.concatLists (
      lib.mapAttrsToList (
        name: serverCfg:
        map (how (text: "In `programs.tsmClient.servers.${name}`: ${text}")) serverCfg."${what}"
      ) cfg.servers
    );

in

{

  inherit options;

  config = lib.mkIf cfg.enable {
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
