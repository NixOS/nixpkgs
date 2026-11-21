# S6 backend for modular services.
#
# Translates the abstract service API (see lib/services/service.nix) into
# s6-rc service directories:
#
#   - /etc/s6/services/<name>/run        executable run script
#   - /etc/s6/services/<name>/type       "longrun" or "oneshot"
#   - /etc/s6/services/<name>/finish     restart-policy controller
#   - /etc/s6/services/<name>/dependencies.d/<dep>  symlinks, resolved within
#     the service tree
#   - /etc/s6/services/<name>/notification-fd       readiness (notify type)
#
# The compiled s6-rc database is exposed as `system.build.s6RcDb`
# (s6-rc-compile output) built from `system.build.s6Services`.
#
# Restart semantics via finish exit codes (125 = permanent down, see
# s6-supervise(8)):
#   - always:     longrun run script loops with restart.delay as sleep
#   - on-failure: run script exits on a clean (0) exit, finish then exits 125
#     (permanent down); failures re-run the loop
#   - never:      run script runs the process once, finish exits 125
#
# `dependencies.wants` and `dependencies.after`/`before` have no exact s6-rc
# equivalent; they are approximated as dependencies.d entries (ordering
# emerges, failure coupling does not follow the abstract semantics).
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
    mapAttrs
    mapAttrsToList
    nameValuePair
    optional
    ;

  inherit (lib.services.backend) dash flattenServices;

  shell = "${pkgs.runtimeShell}";

  allServices = listToAttrs (
    map
      (r: {
        name = r.name;
        value = r;
      })
      (
        lib.filter (r: r.name != "") (
          flattenServices "" "" {
            enable = true;
            services = config.system.services;
          }
        )
      )
  );

  depName = parentPrefix: dep: dash parentPrefix dep;

  # Per-service attributes derived from the abstract API.
  serviceInfo =
    {
      name,
      parentPrefix,
      service,
    }:
    let
      argv = lib.escapeShellArgs service.process.argv;
      # s6-applyuidgid drops to the requested user/group; omitted for root.
      drop =
        if service.runtime.user == "root" then
          ""
        else
          "${pkgs.s6}/bin/s6-applyuidgid -u ${lib.escapeShellArg service.runtime.user} -g ${lib.escapeShellArg service.runtime.group} ";
      preamble = concatStringsSep "\n" (
        (map (v: "export ${v}") (mapAttrsToList (k: v: "${k}=${v}") service.environment))
        ++ optional (service.runtime.workingDirectory != null) "cd ${service.runtime.workingDirectory}"
      );
      sleep = "${pkgs.coreutils}/bin/sleep ${toString service.restart.delay}";
    in
    {
      inherit name parentPrefix service;

      type = if service.process.type == "oneshot" then "oneshot" else "longrun";

      deps = lib.unique (
        (map (d: depName parentPrefix d) service.dependencies.requires)
        ++ (map (d: depName parentPrefix d) service.dependencies.wants)
        ++ (map (d: depName parentPrefix d) service.dependencies.after)
        ++ (map (d: depName parentPrefix d) service.dependencies.before)
      );

      # s6-rc source service directories: oneshots carry an `up` command
      # line (interpreted by execlineb), longruns carry a `run` script.
      oneshotScript = lib.concatLines [
        "#!${shell}"
        preamble
        "exec ${drop}${argv}"
      ];

      runScript =
        if service.restart.policy == "never" then
          lib.concatLines [
            "#!${shell}"
            preamble
            "exec ${drop}${argv}"
          ]
        else if service.restart.policy == "on-failure" then
          lib.concatLines [
            "#!${shell}"
            preamble
            "while true; do"
            "  ${drop}${argv}"
            "  [ $? -eq 0 ] && exit 0"
            "  ${sleep}"
            "done"
          ]
        else
          lib.concatLines [
            "#!${shell}"
            preamble
            "while true; do"
            "  ${drop}${argv}"
            "  ${sleep}"
            "done"
          ];

      # When the run script exits: 125 makes s6-supervise bring the service
      # permanently down (clean exit under on-failure, any exit under never).
      finishScript =
        lib.optionalString (service.process.type != "oneshot" && service.restart.policy != "always")
          (
            if service.restart.policy == "never" then
              ''
                #!/bin/sh
                exit 125
              ''
            else
              ''
                #!/bin/sh
                [ $1 -eq 0 ] && exit 125
                exit 0
              ''
          );

      notificationFd = lib.optionalString (service.process.type == "notify") "4";
    };

  infos = mapAttrs (name: entry: serviceInfo entry) allServices;

  longrunInfos = lib.filterAttrs (name: info: info.type == "longrun") infos;
  oneshotInfos = lib.filterAttrs (name: info: info.type == "oneshot") infos;

  runScripts = mapAttrs (name: info: pkgs.writeText "s6-run-${name}" info.runScript) longrunInfos;
  finishScripts = mapAttrs (name: info: pkgs.writeText "s6-finish-${name}" info.finishScript) (
    lib.filterAttrs (name: info: info.finishScript != "") longrunInfos
  );
  # onshot `up` files are execlineb command lines running the plain shell script
  oneshotScripts = mapAttrs (
    name: info: pkgs.writeText "s6-oneshot-${name}" info.oneshotScript
  ) oneshotInfos;
  upFiles = mapAttrs (
    name: info: pkgs.writeText "s6-up-${name}" "${shell} ${oneshotScripts.${name}}"
  ) oneshotInfos;

  # All service directories in one derivation, so that dependencies.d symlinks
  # resolve inside a single source tree for s6-rc-compile.
  s6Services = pkgs.runCommand "s6-services" { } (
    ''
      mkdir -p $out
    ''
    + concatMapStrings (
      name:
      (
        let
          info = infos.${name};
        in
        ''
          mkdir -p $out/${name}/dependencies.d
          ${
            if info.type == "oneshot" then
              "cp ${upFiles.${name}} $out/${name}/up\n"
            else
              "cp ${runScripts.${name}} $out/${name}/run && chmod 0755 $out/${name}/run\n"
          }
          echo '${info.type}' > $out/${name}/type
          ${lib.optionalString (
            info.type == "longrun" && info.finishScript != ""
          ) "cp ${finishScripts.${name}} $out/${name}/finish && chmod 0755 $out/${name}/finish\n"}
          ${lib.optionalString (
            info.notificationFd != ""
          ) "echo '${info.notificationFd}' > $out/${name}/notification-fd\n"}
          ${concatMapStrings (d: "ln -sfn ../../${d} $out/${name}/dependencies.d/${d}\n") info.deps}
        ''
      )
    ) (builtins.attrNames infos)
  );

  s6RcDb =
    pkgs.runCommand "s6-rc-db"
      {
        nativeBuildInputs = [ pkgs.s6-rc ];
        src = s6Services;
      }
      ''
        s6-rc-compile $out $src
      '';

  configDataFiles = concatLists (
    map (
      entry:
      mapAttrsToList (
        file: cfg:
        nameValuePair "s6/system-services/${entry.name}/${cfg.name}" {
          source = cfg.source;
        }
      ) (lib.filterAttrs (file: cfg: cfg.enable) (entry.service.configData or { }))
    ) (attrValues allServices)
  );
in
{
  _class = "nixos";

  config = lib.mkIf (config.system.initSystem == "s6") {
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

    environment.etc = listToAttrs configDataFiles;

    system.build = {
      inherit s6Services s6RcDb;
    };
  };
}
