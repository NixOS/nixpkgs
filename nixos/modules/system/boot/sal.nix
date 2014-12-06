{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.sal;

in {
  sal.systemName = "nixos";
  sal.processManager.name = "systemd";
  sal.processManager.supports = {
    platforms = pkgs.systemd.meta.platforms;
    fork = true;
    syslog = true;
    users = true;
    privileged = true;
    socketTypes = ["inet" "inet6" "unix"];
    networkNamespaces = false;
  };
  sal.processManager.envNames = {
    mainPid = "MAINPID";
  };

  systemd.services = mapAttrs (n: s:
    let
      mkScript = cmd:
        if cmd != null then
          let c = if cmd.script != null then cmd.script else cmd.command;
          in if !cmd.privileged && s.user != "" && c != "" then ''
            su -s ${pkgs.stdenv.shell} ${s.user} <<'EOF'
            ${c}
            EOF
          '' else c
        else "";

    in mkMerge [
      {
        inherit (s) environment description path;

        wantedBy = [ "multi-user.target" ];
        after = mkMerge [
          (map (n: "${n}.socket") s.requires.sockets)
          (map (n: "${n}.service") s.requires.services)
          (mkIf s.requires.networking ["network.target"])
          (mkIf s.requires.displayManager ["display-manager.service"])
        ];
        requires = config.systemd.services.${n}.after;
        script = mkIf (s.start.script != null) s.start.script;
        preStart = mkIf (s.preStart != null) (mkScript s.preStart);
        postStart = mkIf (s.postStart != null) (mkScript s.postStart);
        preStop = mkIf (s.stop != null) (mkScript s.stop);
        reload = mkIf (s.reload != null) (mkScript s.reload);
        postStop = mkIf (s.postStop != null) (mkScript s.postStop);
        serviceConfig = {
          PIDFile = s.pidFile;
          Type = s.type;
          KillSignal = "SIG" + (toUpper s.stop.stopSignal);
          KillMode = s.stop.stopMode;
          PermissionsStartOnly = true;
          StartTimeout = s.start.timeout;
          StopTimeout = s.stop.timeout;
          User = s.user;
          Group = s.group;
          WorkingDirectory = s.workingDirectory;
        };
      }
      (mkIf (s.start.command != "") {
        serviceConfig.ExecStart =
          if s.start.processName != "" then
            let cmd = head (splitString " " s.start.command);
            in "@${cmd}${s.start.processName}${removePrefix cmd s.start.command}"
          else s.start.command;
      })
      (mkIf (s.requires.dataContainers != []) {
        preStart = mkBefore (
          concatStrings (map (n:
          let
            dc = getAttr n config.sal.dataContainers;
            path = "/var/${dc.type}/${if dc.name != "" then dc.name else n}";

          in ''
            mkdir -m ${dc.mode} -p ${path}
            ${optionalString (dc.user != "") "chown -R ${dc.user} ${path}"}
            ${optionalString (dc.group != "") "chgrp -R ${dc.group} ${path}"}
          ''
          ) s.requires.dataContainers)
        );
      })
      (attrByPath ["systemd"] {} s.extra)
    ]
  ) config.sal.services;

  systemd.sockets = mapAttrs (n: s: {
    inherit (s) description;

    listenStreams = [ s.listen ];
  }) config.sal.sockets;

  sal.dataContainerPaths = mapAttrs (n: dc:
    "/var/${dc.type}/${if dc.name != "" then dc.name else n}"
  ) config.sal.dataContainers;

}
