# Runit backend for modular services.
#
# Translates the abstract service API (see lib/services/service.nix) into
# runit service directories under /etc/runit/services/<name>.
#
# Runit has no native dependency or ordering mechanism, so the dependency
# graph is materialized as:
#   - a `down` file in every service directory, so runsvdir does not start
#     anything on its own, and
#   - a generated boot script (system.build.runitBootScript) that starts the
#     services with `sv up` in topological order (requires/wants before the
#     service, after/before respected as ordering).
#
# Restart semantics (runit restarts nothing after the run script exits):
#   - always:     run script loops (restart.delay as sleep between runs)
#   - on-failure: run script loops, but exits on a clean (0) exit
#   - never:      run script runs the process once
#
# This is opt-in and additive: importing it does not change how systemd or any
# existing NixOS service is translated.
{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrValues
    concatLists
    concatMapStrings
    concatStringsSep
    listToAttrs
    mapAttrsToList
    mkOption
    nameValuePair
    optional
    removePrefix
    types
    ;
  
  inherit (lib.services.backend) configDataPathModule dash flattenServices topoSort;

  shell = "${pkgs.runtimeShell}";

  allServices = listToAttrs (map (r: {
      name = r.name;
      value = r;
    }) (lib.filter (r: r.name != "") (
      flattenServices "" "" {
        enable = true;
        services = config.system.services;
      }
    )));

  depName = parentPrefix: dep: dash parentPrefix dep;

  # Command line, wrapped in chpst when a non-root user is requested.
  # Note: runit's `chpst -u user` sets the user and its primary group; an
  # explicit runtime.group different from the user's primary group is not
  # representable with runit's tools and is therefore left to the process.
  execLine =
    { service, ... }:
    let
      argv = lib.escapeShellArgs service.process.argv;
    in
    if service.runtime.user == "root" then
      "exec ${argv}"
    else
      "exec ${pkgs.runit}/bin/chpst -u ${lib.escapeShellArg service.runtime.user} ${argv}";

  runScript =
    { service, ... }:
    let
      preamble = concatStringsSep "\n" (
        (map (v: "export ${v}") (mapAttrsToList (k: v: "${k}=${v}") service.environment))
        ++ optional (service.runtime.workingDirectory != null) "cd ${service.runtime.workingDirectory}"
      );
      run = execLine { inherit service; };
      sleep = "${pkgs.coreutils}/bin/sleep ${toString service.restart.delay}";
    in
    if service.process.type == "oneshot" then
      lib.concatLines [
        "#!${shell}"
        preamble
        run
      ]
    else if service.restart.policy == "never" then
      lib.concatLines [
        "#!${shell}"
        preamble
        run
      ]
    else if service.restart.policy == "on-failure" then
      lib.concatLines [
        "#!${shell}"
        preamble
        "while true; do"
        "  ${run}"
        "  rc=$?"
        "  [ $rc -eq 0 ] && exit 0"
        "  ${sleep}"
        "done"
      ]
    else
      lib.concatLines [
        "#!${shell}"
        preamble
        "while true; do"
        "  ${run}"
        "  ${sleep}"
        "done"
      ];

  # Topological order over the absolute service names. Edges point from a
  # service to the services that must start before it (after/requires/wants).
  bootOrder' = topoSort (
    name:
    let
      s = allServices.${name}.service;
      p = allServices.${name}.parentPrefix;
    in
    (map (d: depName p d) s.dependencies.after)
    ++ (map (d: depName p d) s.dependencies.requires)
    ++ (map (d: depName p d) s.dependencies.wants)
  ) (builtins.attrNames allServices);

  bootScript = pkgs.writeShellScript "runit-boot" ''
    set -e
    # Starts the modular services in dependency order.
    ${concatMapStrings (name: "sv up /etc/runit/services/${name}\n") bootOrder'}
  '';

  configDataFiles = concatLists (
    map (entry: mapAttrsToList (file: cfg: nameValuePair (
          "runit/system-services/${entry.name}/${cfg.name}"
        ) {
          source = cfg.source;
        }) (lib.filterAttrs (file: cfg: cfg.enable) (entry.service.configData or { }))
    ) (attrValues allServices)
  );
in
{
  _class = "nixos";

  config = lib.mkIf (config.system.initSystem == "runit") {
    assertions = concatLists (
      mapAttrsToList (
        name: cfg: lib.services.getAssertions (options.system.services.loc ++ [ name ]) cfg
      ) config.system.services
    );

    warnings = concatLists (
      mapAttrsToList (
        name: cfg: lib.services.getWarnings (options.system.services.loc ++ [ name ]) cfg
      ) config.system.services
    );

    environment.etc = listToAttrs (
      (mapAttrsToList (name: entry: nameValuePair "runit/services/${name}/run" {
          text = runScript entry;
          mode = "0555";
        }) allServices)
      ++ (map (name: nameValuePair "runit/services/${name}/down" {
          text = "";
        }) (builtins.attrNames allServices))
      ++ configDataFiles
    );

    system.build = {
      runitBootScript = bootScript;
      runitBootOrder = bootOrder';
    };
  };
}