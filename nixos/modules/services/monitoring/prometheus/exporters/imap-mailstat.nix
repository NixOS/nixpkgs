{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.imap-mailstat;
  valueToString =
    value:
    if (builtins.typeOf value == "string") then
      "\"${value}\""
    else
      (
        if (builtins.typeOf value == "int") then
          "${toString value}"
        else
          (
            if (builtins.typeOf value == "bool") then
              (if value then "true" else "false")
            else
              "XXX ${toString value}"
          )
      );
  createConfigFile =
    accounts:
    # unfortunately on toTOML yet
    # https://github.com/NixOS/nix/issues/3929
    pkgs.writeText "imap-mailstat-exporter.conf" ''
      ${lib.concatStrings (
        lib.attrValues (
          lib.mapAttrs (
            name: config:
            "[[Accounts]]\nname = \"${name}\"\n${
              lib.concatStrings (lib.attrValues (lib.mapAttrs (k: v: "${k} = ${valueToString v}\n") config))
            }"
          ) accounts
        )
      )}
    '';
  mkOpt =
    type: description:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = description;
    };
  accountOptions.options = {
    mailaddress = mkOpt lib.types.str "Your email address (at the moment used as login name)";
    username = mkOpt lib.types.str "If empty string mailaddress value is used";
    password = mkOpt lib.types.str "";
    serveraddress = mkOpt lib.types.str "mailserver name or address";
    serverport = mkOpt lib.types.int "imap port number (at the moment only tls connection is supported)";
    starttls = mkOpt lib.types.bool "set to true for using STARTTLS to start a TLS connection";
  };
in
{
  port = 8081;
  extraOpts = {
    oldestUnseenDate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable metric with timestamp of oldest unseen mail
      '';
    };
    accounts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule accountOptions);
      default = { };
      description = ''
        Accounts to monitor
      '';
    };
    configurationFile = lib.mkOption {
      type = lib.types.path;
      example = "/path/to/config-file";
      description = ''
        File containing the configuration
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-imap-mailstat-exporter}/bin/imap-mailstat-exporter \
          -config ${createConfigFile cfg.accounts} \
          ${lib.optionalString cfg.oldestUnseenDate "-oldestunseendate"} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
