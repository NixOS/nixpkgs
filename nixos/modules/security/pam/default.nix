# This module provides configuration for the PAM (Pluggable
# Authentication Modules) system.

{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.security.pam;

  pamEntryModule = entryType: { config, ... }: {
    options = {
      entryType = mkOption {
        type = types.enum [ "account" "auth" "password" "session" ];
        default = entryType;
        internal = true;
        description = ''
          The PAM type for this entry. This should not be set manually.
        '';
      };

      control = mkOption {
        type = utils.pam.controlType;
        description = ''
          The PAM control for this entry. It can be either on of the
          historical basic control keywords, of a set of result-actions pairs.
        '';
        apply = value: if isString value then value else
                      ("[" + concatStringsSep " " (mapAttrsToList (n: v: "${n}=${toString v}") value) + "]");
      };

      path = mkOption {
        type = types.str;
        description = "The path to this entry shared library";
      };

      args = mkOption {
        default = [];
        type = types.listOf types.str;
        description = "Arbitrary string arguments passed to this entry.";
        apply = value: concatStringsSep " " (map toString value);
      };

      order = mkOption {
        type = types.int;
        description = ''
          The order in which this module appears in the PAM service.
          The lower this values, the higher the entry will appear in the
          resulting PAM file.
        '';
      };

      text = mkOption {
        type = types.str;
        description = "The resulting line written to the PAM service.";
        internal = true;
      };
    };

    config = {
      text = ''
        ${config.entryType} ${config.control} ${config.path} ${config.args}
      '';
    };
  };

  entriesType = moduleName: types.orderOf {
    before = a: b: a.value.order < b.value.order;
    elemType = with types; (submodule (pamEntryModule moduleName));
  };

  mkEntriesOption = moduleType: mkOption {
    type = entriesType moduleType;
    description = ''
      The ${moduleType}-type entries of this service.
    '';

  };

  pamServiceModule = { config, ... }: {
    options = {

      account = mkEntriesOption "account";
      auth = mkEntriesOption "auth";
      password = mkEntriesOption "password";
      session = mkEntriesOption "session";

      text = mkOption {
        type = types.str;
        internal = true;
        description = ''
          The resulting text to be written to the PAM service file.
        '';
      };
    };

    config = {
      # FIXME: this mkDefault should be removed once all modules move to the
      # new PAM interface.
      text = mkDefault (concatStringsSep "\n" (map (entry: entry.text) (
        config.account ++ config.auth ++ config.password ++ config.session
      )));
    };
  };

  makePAMService = name: service: {
    name = "pam.d/${name}";
    value.text = service.text;
  };
in
{
  imports = [
    ./modules
  ];

  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule pamServiceModule);
        description = ''
          This option defines the PAM services. A services typically
          corresponds to a program that uses PAM, e.g. <command>login</command>
          or <command>passwd</command>.
          Each attribute of this set defines a PAM service, with the attribute
          name defining the name of the service.
        '';
      };
    };
  };

  config = {
    environment.systemPackages = [ pkgs.pam ];

    security.wrappers = {
      unix_chkpwd = {
        source = "${pkgs.pam}/sbin/unix_chkpwd.orig";
        owner = "root";
        setuid = true;
      };
    };

    environment.etc = mapAttrs' makePAMService config.security.pam.services;

    security.pam.services = {
      other =
        let
          otherEntries = {
            warn = {
              control = "required";
              path = "pam_warn.so";
              order = 1;
            };
            deny = {
              control = "required";
              path = "pam_warn.so";
              order = 2;
            };
          };
        in
        { # TODO: find out what happens if we remove these mkForce
          auth = mkForce otherEntries;
          account = mkForce otherEntries;
          password = mkForce otherEntries;
          session = mkForce otherEntries;
        };

      # Most of these should be moved to specific modules.
      i3lock = {};
      i3lock-color = {};
      vlock = {};
      xlock = {};
      xscreensaver = {};

      runuser.modules = { rootOK = true; unix.enableAuth = true; setEnvironment = false; };

      /* FIXME: should runuser -l start a systemd session? Currently
         it complains "Cannot create session: Already running in a
         session". */
      runuser-l.modules = { rootOK = true; unix.enableAuth = false; };
    };
  };
}
