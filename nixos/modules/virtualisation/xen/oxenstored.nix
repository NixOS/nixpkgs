# Xen Project Hypervisor OCaml-based Xen Store Daemon configuration.
# Used in dom0 by default, but can also be used in a stubdomain.
{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  inherit (lib)
    attrByPath
    hasSuffix
    literalExpression
    mkIf
    mkOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    types
    ;
  inherit (types) enum path;

  cfg = config.virtualisation.xen;

  settingsFormat = pkgs.formats.keyValue { };
in
{
  imports = [
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "debug"
      ]
      "The debug option no longer does anything, as all oxenstored debugging features can be enabled with 'virtualisation.xen.store.settings'."
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "stored"
      ]
      [
        "virtualisation"
        "xen"
        "store"
        "path"
      ]
    )
  ];
  ## Interface ##

  options.virtualisation.xen.store = {
    path = mkOption {
      type = path;
      default = "${cfg.package}/bin/oxenstored";
      defaultText = literalExpression "\${config.virtualisation.xen.package}/bin/oxenstored";
      example = literalExpression "\${config.virtualisation.xen.package}/bin/xenstored";
      description = ''
        Path to the Xen Store Daemon. This option is useful to
        switch between the legacy C-based Xen Store Daemon, and
        the newer OCaml-based Xen Store Daemon, `oxenstored`.
      '';
    };
    type = mkOption {
      type = enum [
        "c"
        "ocaml"
      ];
      default = if (hasSuffix "oxenstored" cfg.store.path) then "ocaml" else "c";
      internal = true;
      readOnly = true;
      description = "Helper internal option that determines the type of the Xen Store Daemon based on cfg.store.path.";
    };
    settings = mkOption {
      inherit (settingsFormat) type;
      default = {
        access-log-file = "/var/log/xen/xenstored-access.log";
        access-log-nb-lines = 13215;
        access-log-special-ops = false;
        acesss-log-nb-chars = 180;
        conflict-burst-limit = 5.0;
        conflict-max-history-seconds = 5.0e-2;
        conflict-rate-limit-is-aggregate = 1;
        merge-activate = 1;
        perms-activate = 1;
        perms-watch-activate = 1;
        persistent = false;
        pid-file = "/run/xen/xenstored.pid";
        quota-activate = 1;
        quota-maxentity = 1000;
        quota-maxoutstanding = 1024;
        quota-maxrequests = 1024;
        quota-maxsize = 2048;
        quota-maxwatch = 100;
        quota-maxwatchevents = 1024;
        quota-path-max = 1024;
        quota-transaction = 10;
        ring-scan-interval = 20;
        test-eagain = false;
        xenstored-kva = "/proc/xen/xsd_kva";
        xenstored-log-file = "/var/log/xen/xenstored.log";
        xenstored-log-level = "debug";
        xenstored-log-nb-files = 10;
        xenstored-port = "/proc/xen/xsd_port";
      };
      example = {
        conflict-burst-limit = 15.0;
        conflict-max-history-seconds = 0.12;
        merge-activate = false;
        quota-activate = true;
        quota-maxwatchevents = 2048;
        xenstored-log-file = "/dev/null";
        xenstored-log-level = "info";
      };
      description = ''
        The OCaml-based Xen Store Daemon configuration. This
        option does nothing with the C-based `xenstored`.
      '';
    };
  };

  ## Implementation ##

  config = mkIf (cfg.enable && cfg.store.type == "ocaml") {
    assertions = [
      {
        assertion =
          (attrByPath [ "quota-maxwatchevents" ] 1024 cfg.store.settings)
          >= (attrByPath [ "quota-maxoutstanding" ] 1024 cfg.store.settings);
        message = ''
          Upstream Xen recommends that quota-maxwatchevents be equal to or greater than quota-maxoutstanding,
          in order to mitigate denial of service attacks from malicious frontends.
        '';
      }
    ];
    environment.etc."xen/oxenstored.conf".source = settingsFormat.generate "oxenstored.conf" (
      options.virtualisation.xen.store.settings.default // cfg.store.settings
    );
  };
}
