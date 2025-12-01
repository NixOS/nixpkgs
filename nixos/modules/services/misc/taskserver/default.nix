{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.taskserver;

  taskd = "${pkgs.taskserver}/bin/taskd";

  mkManualPkiOption =
    desc:
    lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        ${desc}

        ::: {.note}
        Setting this option will prevent automatic CA creation and handling.
        :::
      '';
    };

  manualPkiOptions = {
    ca.cert = mkManualPkiOption ''
      Fully qualified path to the CA certificate.
    '';

    server.cert = mkManualPkiOption ''
      Fully qualified path to the server certificate.
    '';

    server.crl = mkManualPkiOption ''
      Fully qualified path to the server certificate revocation list.
    '';

    server.key = mkManualPkiOption ''
      Fully qualified path to the server key.
    '';
  };

  mkAutoDesc = preamble: ''
    ${preamble}

    ::: {.note}
    This option is for the automatically handled CA and will be ignored if any
    of the {option}`services.taskserver.pki.manual.*` options are set.
    :::
  '';

  mkExpireOption =
    desc:
    lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 365;
      apply = val: if val == null then -1 else val;
      description = mkAutoDesc ''
        The expiration time of ${desc} in days or `null` for no
        expiration time.
      '';
    };

  autoPkiOptions = {
    bits = lib.mkOption {
      type = lib.types.int;
      default = 4096;
      example = 2048;
      description = mkAutoDesc "The bit size for generated keys.";
    };

    expiration = {
      ca = mkExpireOption "the CA certificate";
      server = mkExpireOption "the server certificate";
      client = mkExpireOption "client certificates";
      crl = mkExpireOption "the certificate revocation list (CRL)";
    };
  };

  needToCreateCA =
    let
      notFound =
        path:
        let
          dotted = lib.concatStringsSep "." path;
        in
        throw "Can't find option definitions for path `${dotted}'.";
      findPkiDefinitions =
        path: attrs:
        let
          mkSublist =
            key: val:
            let
              newPath = path ++ lib.singleton key;
            in
            if lib.isOption val then
              lib.attrByPath newPath (notFound newPath) cfg.pki.manual
            else
              findPkiDefinitions newPath val;
        in
        lib.flatten (lib.mapAttrsToList mkSublist attrs);
    in
    lib.all (x: x == null) (findPkiDefinitions [ ] manualPkiOptions);

  orgOptions =
    { ... }:
    {
      options.users = lib.mkOption {
        type = lib.types.uniq (lib.types.listOf lib.types.str);
        default = [ ];
        example = [
          "alice"
          "bob"
        ];
        description = ''
          A list of user names that belong to the organization.
        '';
      };

      options.groups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "workers"
          "slackers"
        ];
        description = ''
          A list of group names that belong to the organization.
        '';
      };
    };

  certtool = "${pkgs.gnutls.bin}/bin/certtool";

  nixos-taskserver =
    with pkgs.python3.pkgs;
    buildPythonApplication {
      format = "setuptools";
      name = "nixos-taskserver";

      src = pkgs.runCommand "nixos-taskserver-src" { } ''
        mkdir -p "$out"
        cat "${
          pkgs.replaceVars ./helper-tool.py {
            inherit taskd certtool;
            inherit (cfg)
              dataDir
              user
              group
              fqdn
              ;
            certBits = cfg.pki.auto.bits;
            clientExpiration = cfg.pki.auto.expiration.client;
            crlExpiration = cfg.pki.auto.expiration.crl;
            isAutoConfig = if needToCreateCA then "True" else "False";
          }
        }" > "$out/main.py"
        cat > "$out/setup.py" <<EOF
        from setuptools import setup
        setup(name="nixos-taskserver",
              py_modules=["main"],
              install_requires=["Click"],
              entry_points="[console_scripts]\\nnixos-taskserver=main:cli")
        EOF
      '';

      propagatedBuildInputs = [ click ];
    };

in
{
  options = {
    services.taskserver = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description =
          let
            url = "https://nixos.org/manual/nixos/stable/index.html#module-services-taskserver";
          in
          ''
            Whether to enable the Taskwarrior 2 server.

            More instructions about NixOS in conjunction with Taskserver can be
            found [in the NixOS manual](${url}).
          '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "taskd";
        description = "User for Taskserver.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "taskd";
        description = "Group for Taskserver.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/taskserver";
        description = "Data directory for Taskserver.";
      };

      ciphers = lib.mkOption {
        type = lib.types.nullOr (lib.types.separatedString ":");
        default = null;
        example = "NORMAL:-VERS-SSL3.0";
        description =
          let
            url = "https://gnutls.org/manual/html_node/Priority-Strings.html";
          in
          ''
            List of GnuTLS ciphers to use. See the GnuTLS documentation about
            priority strings at <${url}> for full details.
          '';
      };

      organisations = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule orgOptions);
        default = { };
        example.myShinyOrganisation.users = [
          "alice"
          "bob"
        ];
        example.myShinyOrganisation.groups = [
          "staff"
          "outsiders"
        ];
        example.yetAnotherOrganisation.users = [
          "foo"
          "bar"
        ];
        description = ''
          An attribute set where the keys name the organisation and the values
          are a set of lists of {option}`users` and
          {option}`groups`.
        '';
      };

      confirmation = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Determines whether certain commands are confirmed.
        '';
      };

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Logs debugging information.
        '';
      };

      extensions = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Fully qualified path of the Taskserver extension scripts.
          Currently there are none.
        '';
      };

      ipLog = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Logs the IP addresses of incoming requests.
        '';
      };

      queueSize = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = ''
          Size of the connection backlog, see {manpage}`listen(2)`.
        '';
      };

      requestLimit = lib.mkOption {
        type = lib.types.int;
        default = 1048576;
        description = ''
          Size limit of incoming requests, in bytes.
        '';
      };

      allowedClientIDs = lib.mkOption {
        type = with lib.types; either str (listOf str);
        default = [ ];
        example = [ "[Tt]ask [2-9]+" ];
        description = ''
          A list of regular expressions that are matched against the reported
          client id (such as `task 2.3.0`).

          The values `all` or `none` have
          special meaning. Overridden by any entry in the option
          {option}`services.taskserver.disallowedClientIDs`.
        '';
      };

      disallowedClientIDs = lib.mkOption {
        type = with lib.types; either str (listOf str);
        default = [ ];
        example = [ "[Tt]ask [2-9]+" ];
        description = ''
          A list of regular expressions that are matched against the reported
          client id (such as `task 2.3.0`).

          The values `all` or `none` have
          special meaning. Any entry here overrides those in
          {option}`services.taskserver.allowedClientIDs`.
        '';
      };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        example = "::";
        description = ''
          The address (IPv4, IPv6 or DNS) to listen on.
        '';
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 53589;
        description = ''
          Port number of the Taskserver.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the specified Taskserver port.
        '';
      };

      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          The fully qualified domain name of this server, which is also used
          as the common name in the certificates.
        '';
      };

      trust = lib.mkOption {
        type = lib.types.enum [
          "allow all"
          "strict"
        ];
        default = "strict";
        description = ''
          Determines how client certificates are validated.

          The value `allow all` performs no client
          certificate validation. This is not recommended. The value
          `strict` causes the client certificate to be
          validated against a CA.
        '';
      };

      pki.manual = manualPkiOptions;
      pki.auto = autoPkiOptions;

      config = lib.mkOption {
        type = lib.types.attrs;
        example.client.cert = "/tmp/debugging.cert";
        description = ''
          Configuration options to pass to Taskserver.

          The options here are the same as described in
          {manpage}`taskdrc(5)` from the `taskwarrior2` package, but with one difference:

          The `server` option is
          `server.listen` here, because the
          `server` option would collide with other options
          like `server.cert` and we would run in a type error
          (attribute set versus string).

          Nix types like integers or booleans are automatically converted to
          the right values Taskserver would expect.
        '';
        apply =
          let
            mkKey =
              path:
              if
                path == [
                  "server"
                  "listen"
                ]
              then
                "server"
              else
                lib.concatStringsSep "." path;
            recurse =
              path: attrs:
              let
                mapper =
                  name: val:
                  let
                    newPath = path ++ [ name ];
                    scalar =
                      if val == true then
                        "true"
                      else if val == false then
                        "false"
                      else
                        toString val;
                  in
                  if lib.isAttrs val then recurse newPath val else [ "${mkKey newPath}=${scalar}" ];
              in
              lib.concatLists (lib.mapAttrsToList mapper attrs);
          in
          recurse [ ];
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "taskserver" "extraConfig" ] ''
      This option was removed in favor of `services.taskserver.config` with
      different semantics (it's now a list of attributes instead of lines).

      Please look up the documentation of `services.taskserver.config' to get
      more information about the new way to pass additional configuration
      options.
    '')
  ];

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ nixos-taskserver ];

      users.users = lib.optionalAttrs (cfg.user == "taskd") {
        taskd = {
          uid = config.ids.uids.taskd;
          description = "Taskserver user";
          group = cfg.group;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == "taskd") {
        taskd.gid = config.ids.gids.taskd;
      };

      services.taskserver.config = {
        # systemd related
        daemon = false;
        log = "-";

        # logging
        debug = cfg.debug;
        ip.log = cfg.ipLog;

        # general
        ciphers = cfg.ciphers;
        confirmation = cfg.confirmation;
        extensions = cfg.extensions;
        queue.size = cfg.queueSize;
        request.limit = cfg.requestLimit;

        # client
        client.allow = cfg.allowedClientIDs;
        client.deny = cfg.disallowedClientIDs;

        # server
        trust = cfg.trust;
        server = {
          listen = "${cfg.listenHost}:${toString cfg.listenPort}";
        }
        // (
          if needToCreateCA then
            {
              cert = "${cfg.dataDir}/keys/server.cert";
              key = "${cfg.dataDir}/keys/server.key";
              crl = "${cfg.dataDir}/keys/server.crl";
            }
          else
            {
              cert = "${cfg.pki.manual.server.cert}";
              key = "${cfg.pki.manual.server.key}";
              ${lib.mapNullable (_: "crl") cfg.pki.manual.server.crl} = "${cfg.pki.manual.server.crl}";
            }
        );

        ca.cert = if needToCreateCA then "${cfg.dataDir}/keys/ca.cert" else "${cfg.pki.manual.ca.cert}";
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0770 ${cfg.user} ${cfg.group}"
        "z ${cfg.dataDir} 0770 ${cfg.user} ${cfg.group}"
      ];

      systemd.services.taskserver-init = {
        wantedBy = [ "taskserver.service" ];
        before = [ "taskserver.service" ];
        description = "Initialize Taskserver Data Directory";

        script = ''
          ${taskd} init
          touch "${cfg.dataDir}/.is_initialized"
        '';

        environment.TASKDDATA = cfg.dataDir;

        unitConfig.ConditionPathExists = "!${cfg.dataDir}/.is_initialized";

        serviceConfig.Type = "oneshot";
        serviceConfig.User = cfg.user;
        serviceConfig.Group = cfg.group;
        serviceConfig.PermissionsStartOnly = true;
        serviceConfig.PrivateNetwork = true;
        serviceConfig.PrivateDevices = true;
        serviceConfig.PrivateTmp = true;
      };

      systemd.services.taskserver = {
        description = "Taskwarrior 2 Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.TASKDDATA = cfg.dataDir;

        preStart =
          let
            jsonOrgs = builtins.toJSON cfg.organisations;
            jsonFile = pkgs.writeText "orgs.json" jsonOrgs;
            helperTool = "${nixos-taskserver}/bin/nixos-taskserver";
          in
          "${helperTool} process-json '${jsonFile}'";

        serviceConfig = {
          ExecStart =
            let
              mkCfgFlag = flag: lib.escapeShellArg "--${flag}";
              cfgFlags = lib.concatMapStringsSep " " mkCfgFlag cfg.config;
            in
            "@${taskd} taskd server ${cfgFlags}";
          ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
          Restart = "on-failure";
          PermissionsStartOnly = true;
          PrivateTmp = true;
          PrivateDevices = true;
          User = cfg.user;
          Group = cfg.group;
        };
      };
    })
    (lib.mkIf (cfg.enable && needToCreateCA) {
      systemd.services.taskserver-ca = {
        wantedBy = [ "taskserver.service" ];
        after = [ "taskserver-init.service" ];
        before = [ "taskserver.service" ];
        description = "Initialize CA for TaskServer";
        serviceConfig.Type = "oneshot";
        serviceConfig.UMask = "0077";
        serviceConfig.PrivateNetwork = true;
        serviceConfig.PrivateTmp = true;

        script = ''
          silent_certtool() {
            if ! output="$("${certtool}" "$@" 2>&1)"; then
              echo "GNUTLS certtool invocation failed with output:" >&2
              echo "$output" >&2
            fi
          }

          mkdir -m 0700 -p "${cfg.dataDir}/keys"
          chown root:root "${cfg.dataDir}/keys"

          if [ ! -e "${cfg.dataDir}/keys/ca.key" ]; then
            silent_certtool -p \
              --bits ${toString cfg.pki.auto.bits} \
              --outfile "${cfg.dataDir}/keys/ca.key"
            silent_certtool -s \
              --template "${pkgs.writeText "taskserver-ca.template" ''
                cn = ${cfg.fqdn}
                expiration_days = ${toString cfg.pki.auto.expiration.ca}
                cert_signing_key
                ca
              ''}" \
              --load-privkey "${cfg.dataDir}/keys/ca.key" \
              --outfile "${cfg.dataDir}/keys/ca.cert"

            chgrp "${cfg.group}" "${cfg.dataDir}/keys/ca.cert"
            chmod g+r "${cfg.dataDir}/keys/ca.cert"
          fi

          if [ ! -e "${cfg.dataDir}/keys/server.key" ]; then
            silent_certtool -p \
              --bits ${toString cfg.pki.auto.bits} \
              --outfile "${cfg.dataDir}/keys/server.key"

            silent_certtool -c \
              --template "${pkgs.writeText "taskserver-cert.template" ''
                cn = ${cfg.fqdn}
                expiration_days = ${toString cfg.pki.auto.expiration.server}
                tls_www_server
                encryption_key
                signing_key
              ''}" \
              --load-ca-privkey "${cfg.dataDir}/keys/ca.key" \
              --load-ca-certificate "${cfg.dataDir}/keys/ca.cert" \
              --load-privkey "${cfg.dataDir}/keys/server.key" \
              --outfile "${cfg.dataDir}/keys/server.cert"

            chgrp "${cfg.group}" \
              "${cfg.dataDir}/keys/server.key" \
              "${cfg.dataDir}/keys/server.cert"

            chmod g+r \
              "${cfg.dataDir}/keys/server.key" \
              "${cfg.dataDir}/keys/server.cert"
          fi

          if [ ! -e "${cfg.dataDir}/keys/server.crl" ]; then
            silent_certtool --generate-crl \
              --template "${pkgs.writeText "taskserver-crl.template" ''
                expiration_days = ${toString cfg.pki.auto.expiration.crl}
              ''}" \
              --load-ca-privkey "${cfg.dataDir}/keys/ca.key" \
              --load-ca-certificate "${cfg.dataDir}/keys/ca.cert" \
              --outfile "${cfg.dataDir}/keys/server.crl"

            chgrp "${cfg.group}" "${cfg.dataDir}/keys/server.crl"
            chmod g+r "${cfg.dataDir}/keys/server.crl"
          fi

          chmod go+x "${cfg.dataDir}/keys"
        '';
      };
    })
    (lib.mkIf (cfg.enable && cfg.openFirewall) {
      networking.firewall.allowedTCPPorts = [ cfg.listenPort ];
    })
  ];

  meta.doc = ./default.md;
}
