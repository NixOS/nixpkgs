{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.taskserver;

  taskd = "${pkgs.taskserver}/bin/taskd";

  mkManualPkiOption = desc: mkOption {
    type = types.nullOr types.path;
    default = null;
    description = desc + ''
      <note><para>
      Setting this option will prevent automatic CA creation and handling.
      </para></note>
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

    <note><para>
    This option is for the automatically handled CA and will be ignored if any
    of the <option>services.taskserver.pki.manual.*</option> options are set.
    </para></note>
  '';

  mkExpireOption = desc: mkOption {
    type = types.nullOr types.int;
    default = null;
    example = 365;
    apply = val: if val == null then -1 else val;
    description = mkAutoDesc ''
      The expiration time of ${desc} in days or <literal>null</literal> for no
      expiration time.
    '';
  };

  autoPkiOptions = {
    bits = mkOption {
      type = types.int;
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

  needToCreateCA = let
    notFound = path: let
      dotted = concatStringsSep "." path;
    in throw "Can't find option definitions for path `${dotted}'.";
    findPkiDefinitions = path: attrs: let
      mkSublist = key: val: let
        newPath = path ++ singleton key;
      in if isOption val
         then attrByPath newPath (notFound newPath) cfg.pki.manual
         else findPkiDefinitions newPath val;
    in flatten (mapAttrsToList mkSublist attrs);
  in all (x: x == null) (findPkiDefinitions [] manualPkiOptions);

  orgOptions = { ... }: {
    options.users = mkOption {
      type = types.uniq (types.listOf types.str);
      default = [];
      example = [ "alice" "bob" ];
      description = ''
        A list of user names that belong to the organization.
      '';
    };

    options.groups = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "workers" "slackers" ];
      description = ''
        A list of group names that belong to the organization.
      '';
    };
  };

  certtool = "${pkgs.gnutls.bin}/bin/certtool";

  nixos-taskserver = pkgs.pythonPackages.buildPythonApplication {
    name = "nixos-taskserver";

    src = pkgs.runCommand "nixos-taskserver-src" { preferLocalBuild = true; } ''
      mkdir -p "$out"
      cat "${pkgs.substituteAll {
        src = ./helper-tool.py;
        inherit taskd certtool;
        inherit (cfg) dataDir user group fqdn;
        certBits = cfg.pki.auto.bits;
        clientExpiration = cfg.pki.auto.expiration.client;
        crlExpiration = cfg.pki.auto.expiration.crl;
        isAutoConfig = if needToCreateCA then "True" else "False";
      }}" > "$out/main.py"
      cat > "$out/setup.py" <<EOF
      from setuptools import setup
      setup(name="nixos-taskserver",
            py_modules=["main"],
            install_requires=["Click"],
            entry_points="[console_scripts]\\nnixos-taskserver=main:cli")
      EOF
    '';

    propagatedBuildInputs = [ pkgs.pythonPackages.click ];
  };

in {
  options = {
    services.taskserver = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Taskwarrior server.

          More instructions about NixOS in conjuction with Taskserver can be
          found in the NixOS manual at
          <olink targetdoc="manual" targetptr="module-taskserver"/>.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "taskd";
        description = "User for Taskserver.";
      };

      group = mkOption {
        type = types.str;
        default = "taskd";
        description = "Group for Taskserver.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/taskserver";
        description = "Data directory for Taskserver.";
      };

      ciphers = mkOption {
        type = types.nullOr (types.separatedString ":");
        default = null;
        example = "NORMAL:-VERS-SSL3.0";
        description = let
          url = "https://gnutls.org/manual/html_node/Priority-Strings.html";
        in ''
          List of GnuTLS ciphers to use. See the GnuTLS documentation about
          priority strings at <link xlink:href="${url}"/> for full details.
        '';
      };

      organisations = mkOption {
        type = types.attrsOf (types.submodule orgOptions);
        default = {};
        example.myShinyOrganisation.users = [ "alice" "bob" ];
        example.myShinyOrganisation.groups = [ "staff" "outsiders" ];
        example.yetAnotherOrganisation.users = [ "foo" "bar" ];
        description = ''
          An attribute set where the keys name the organisation and the values
          are a set of lists of <option>users</option> and
          <option>groups</option>.
        '';
      };

      confirmation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Determines whether certain commands are confirmed.
        '';
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Logs debugging information.
        '';
      };

      extensions = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Fully qualified path of the Taskserver extension scripts.
          Currently there are none.
        '';
      };

      ipLog = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Logs the IP addresses of incoming requests.
        '';
      };

      queueSize = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Size of the connection backlog, see <citerefentry>
            <refentrytitle>listen</refentrytitle>
            <manvolnum>2</manvolnum>
          </citerefentry>.
        '';
      };

      requestLimit = mkOption {
        type = types.int;
        default = 1048576;
        description = ''
          Size limit of incoming requests, in bytes.
        '';
      };

      allowedClientIDs = mkOption {
        type = with types; either str (listOf str);
        default = [];
        example = [ "[Tt]ask [2-9]+" ];
        description = ''
          A list of regular expressions that are matched against the reported
          client id (such as <literal>task 2.3.0</literal>).

          The values <literal>all</literal> or <literal>none</literal> have
          special meaning. Overidden by any entry in the option
          <option>services.taskserver.disallowedClientIDs</option>.
        '';
      };

      disallowedClientIDs = mkOption {
        type = with types; either str (listOf str);
        default = [];
        example = [ "[Tt]ask [2-9]+" ];
        description = ''
          A list of regular expressions that are matched against the reported
          client id (such as <literal>task 2.3.0</literal>).

          The values <literal>all</literal> or <literal>none</literal> have
          special meaning. Any entry here overrides those in
          <option>services.taskserver.allowedClientIDs</option>.
        '';
      };

      listenHost = mkOption {
        type = types.str;
        default = "localhost";
        example = "::";
        description = ''
          The address (IPv4, IPv6 or DNS) to listen on.

          If the value is something else than <literal>localhost</literal> the
          port defined by <option>listenPort</option> is automatically added to
          <option>networking.firewall.allowedTCPPorts</option>.
        '';
      };

      listenPort = mkOption {
        type = types.int;
        default = 53589;
        description = ''
          Port number of the Taskserver.
        '';
      };

      fqdn = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The fully qualified domain name of this server, which is also used
          as the common name in the certificates.
        '';
      };

      trust = mkOption {
        type = types.enum [ "allow all" "strict" ];
        default = "strict";
        description = ''
          Determines how client certificates are validated.

          The value <literal>allow all</literal> performs no client
          certificate validation. This is not recommended. The value
          <literal>strict</literal> causes the client certificate to be
          validated against a CA.
        '';
      };

      pki.manual = manualPkiOptions;
      pki.auto = autoPkiOptions;

      config = mkOption {
        type = types.attrs;
        example.client.cert = "/tmp/debugging.cert";
        description = ''
          Configuration options to pass to Taskserver.

          The options here are the same as described in <citerefentry>
            <refentrytitle>taskdrc</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>, but with one difference:

          The <literal>server</literal> option is
          <literal>server.listen</literal> here, because the
          <literal>server</literal> option would collide with other options
          like <literal>server.cert</literal> and we would run in a type error
          (attribute set versus string).

          Nix types like integers or booleans are automatically converted to
          the right values Taskserver would expect.
        '';
        apply = let
          mkKey = path: if path == ["server" "listen"] then "server"
                        else concatStringsSep "." path;
          recurse = path: attrs: let
            mapper = name: val: let
              newPath = path ++ [ name ];
              scalar = if val == true then "true"
                       else if val == false then "false"
                       else toString val;
            in if isAttrs val then recurse newPath val
               else [ "${mkKey newPath}=${scalar}" ];
          in concatLists (mapAttrsToList mapper attrs);
        in recurse [];
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "taskserver" "extraConfig"] ''
      This option was removed in favor of `services.taskserver.config` with
      different semantics (it's now a list of attributes instead of lines).

      Please look up the documentation of `services.taskserver.config' to get
      more information about the new way to pass additional configuration
      options.
    '')
  ];

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [ nixos-taskserver ];

      users.users = optional (cfg.user == "taskd") {
        name = "taskd";
        uid = config.ids.uids.taskd;
        description = "Taskserver user";
        group = cfg.group;
      };

      users.groups = optional (cfg.group == "taskd") {
        name = "taskd";
        gid = config.ids.gids.taskd;
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
        } // (if needToCreateCA then {
          cert = "${cfg.dataDir}/keys/server.cert";
          key = "${cfg.dataDir}/keys/server.key";
          crl = "${cfg.dataDir}/keys/server.crl";
        } else {
          cert = "${cfg.pki.manual.server.cert}";
          key = "${cfg.pki.manual.server.key}";
          crl = "${cfg.pki.manual.server.crl}";
        });

        ca.cert = if needToCreateCA then "${cfg.dataDir}/keys/ca.cert"
                  else "${cfg.pki.manual.ca.cert}";
      };

      systemd.services.taskserver-init = {
        wantedBy = [ "taskserver.service" ];
        before = [ "taskserver.service" ];
        description = "Initialize Taskserver Data Directory";

        preStart = ''
          mkdir -m 0770 -p "${cfg.dataDir}"
          chown "${cfg.user}:${cfg.group}" "${cfg.dataDir}"
        '';

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
        description = "Taskwarrior Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.TASKDDATA = cfg.dataDir;

        preStart = let
          jsonOrgs = builtins.toJSON cfg.organisations;
          jsonFile = pkgs.writeText "orgs.json" jsonOrgs;
          helperTool = "${nixos-taskserver}/bin/nixos-taskserver";
        in "${helperTool} process-json '${jsonFile}'";

        serviceConfig = {
          ExecStart = let
            mkCfgFlag = flag: escapeShellArg "--${flag}";
            cfgFlags = concatMapStringsSep " " mkCfgFlag cfg.config;
          in "@${taskd} taskd server ${cfgFlags}";
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
    (mkIf (cfg.enable && needToCreateCA) {
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
    (mkIf (cfg.enable && cfg.listenHost != "localhost") {
      networking.firewall.allowedTCPPorts = [ cfg.listenPort ];
    })
  ];

  meta.doc = ./doc.xml;
}
