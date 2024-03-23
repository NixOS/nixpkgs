{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.imap-mailstat;
  valueToString = value:
    if (builtins.typeOf value == "string") then "\"${value}\""
    else (
      if (builtins.typeOf value == "int") then "${toString value}"
      else (
        if (builtins.typeOf value == "bool") then (if value then "true" else "false")
        else "XXX ${toString value}"
      )
    );
  createConfigFile = accounts:
    # unfortunately on toTOML yet
    # https://github.com/NixOS/nix/issues/3929
    pkgs.writeText "imap-mailstat-exporter.conf" ''
      ${concatStrings (attrValues (mapAttrs (name: config: "[[Accounts]]\nname = \"${name}\"\n${concatStrings (attrValues (mapAttrs (k: v: "${k} = ${valueToString v}\n") config))}") accounts))}
    '';
  mkOpt = type: description: mkOption {
    type = types.nullOr type;
    default = null;
    description = lib.mdDoc description;
  };
  accountOptions.options = {
    mailaddress = mkOpt types.str "Your email address (at the moment used as login name)";
    username = mkOpt types.str "If empty string mailaddress value is used";
    password = mkOpt types.str "";
    serveraddress = mkOpt types.str "mailserver name or address";
    serverport = mkOpt types.int "imap port number (at the moment only tls connection is supported)";
    starttls = mkOpt types.bool "set to true for using STARTTLS to start a TLS connection";
  };
in
{
  port = 8081;
  extraOpts = {
    oldestUnseenDate = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable metric with timestamp of oldest unseen mail
      '';
    };
    accounts = mkOption {
      type = types.attrsOf (types.submodule accountOptions);
      default = {};
      description = lib.mdDoc ''
        Accounts to monitor
      '';
    };
    configurationFile = mkOption {
      type = types.path;
      example = "/path/to/config-file";
      description = lib.mdDoc ''
        File containing the configuration
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-imap-mailstat-exporter}/bin/imap-mailstat-exporter \
          -config ${createConfigFile cfg.accounts} \
          ${optionalString cfg.oldestUnseenDate "-oldestunseendate"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
