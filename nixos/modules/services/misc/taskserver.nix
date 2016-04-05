{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.taskserver;

  taskd = "${pkgs.taskserver}/bin/taskd";

  mkVal = val:
    if val == true then "true"
    else if val == false then "false"
    else if isList val then concatStringsSep ", " val
    else toString val;

  mkConfLine = key: val: let
    result = "${key} = ${mkVal val}";
  in optionalString (val != null && val != []) result;

  needToCreateCA = all isNull (with cfg; [
    server.key server.cert server.crl caCert
  ]);

  configFile = pkgs.writeText "taskdrc" ''
    # systemd related
    daemon = false
    log = -

    # logging
    ${mkConfLine "debug" cfg.debug}
    ${mkConfLine "ip.log" cfg.ipLog}

    # general
    ${mkConfLine "ciphers" cfg.ciphers}
    ${mkConfLine "confirmation" cfg.confirmation}
    ${mkConfLine "extensions" cfg.extensions}
    ${mkConfLine "queue.size" cfg.queueSize}
    ${mkConfLine "request.limit" cfg.requestLimit}

    # client
    ${mkConfLine "client.cert" cfg.client.cert}
    ${mkConfLine "client.allow" cfg.client.allow}
    ${mkConfLine "client.deny" cfg.client.deny}

    # server
    server = ${cfg.server.host}:${toString cfg.server.port}
    ${mkConfLine "server.crl" cfg.server.crl}

    # certificates
    ${mkConfLine "trust" cfg.server.trust}
    ${if needToCreateCA then ''
      ca.cert = ${cfg.dataDir}/keys/ca.cert
      server.cert = ${cfg.dataDir}/keys/server.cert
      server.key = ${cfg.dataDir}/keys/server.key
    '' else ''
      ca.cert = ${cfg.caCert}
      server.cert = ${cfg.server.cert}
      server.key = ${cfg.server.key}
    ''}
  '';

  genClientKey = ''
    umask 0077
    if tmpdir="$(${pkgs.coreutils}/bin/mktemp -d)"; then
      trap "rm -rf '$tmpdir'" EXIT
      ${pkgs.gnutls}/bin/certtool -p --bits 2048 --outfile "$tmpdir/key"

      cat > "$tmpdir/template" <<-\ \ EOF
      organization = $organisation
      cn = ${cfg.server.fqdn}
      tls_www_client
      encryption_key
      signing_key
      EOF

      ${pkgs.gnutls}/bin/certtool -c \
        --load-privkey "$tmpdir/key" \
        --load-ca-privkey "${cfg.dataDir}/keys/ca.key" \
        --load-ca-certificate "${cfg.dataDir}/keys/ca.cert" \
        --template "$tmpdir/template" \
        --outfile "$tmpdir/cert"

      mkdir -m 0700 -p "${cfg.dataDir}/keys/user/$organisation/$user"
      chown root:root "${cfg.dataDir}/keys/user/$organisation/$user"
      cat "$tmpdir/key" \
        > "${cfg.dataDir}/keys/user/$organisation/$user/private.key"
      cat "$tmpdir/cert" \
        > "${cfg.dataDir}/keys/user/$organisation/$user/public.cert"

      rm -rf "$tmpdir"
      trap - EXIT
    else
      echo "Unable to create temporary directory for client" \
           "certificate creation." >&2
      exit 1
    fi
  '';

  orgOptions = { name, ... }: {
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

  mkShellStr = val: "'${replaceStrings ["'"] ["'\\''"] val}'";
  mkShellName = replaceStrings ["-"] ["_"];

  mkSubCommand = name: { args, description, script }: let
    mkArg = pos: arg: "local ${arg}=\"\$${toString pos}\"";
    mkDesc = line: "echo ${mkShellStr "    ${line}"} >&2";
    usagePosArgs = concatMapStringsSep " " (a: "<${a}>") args;
  in ''
    subcmd_${mkShellName name}() {
      ${concatImapStringsSep "\n  " mkArg args}
      ${script}
    }

    usage_${mkShellName name}() {
      echo "  nixos-taskdctl ${name} ${usagePosArgs}" >&2
      ${concatMapStringsSep "\n  " mkDesc description}
    }
  '';

  mkCStr = val: "\"${escape ["\\" "\""] val}\"";

  taskdUser = let
    runUser = pkgs.writeText "runuser.c" ''
      #include <sys/types.h>
      #include <pwd.h>
      #include <grp.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <errno.h>
      #include <unistd.h>

      int main(int argc, char **argv) {
        struct passwd *userinfo;
        struct group *groupinfo;
        errno = 0;
        if ((userinfo = getpwnam(${mkCStr cfg.user})) == NULL) {
          if (errno == 0)
            fputs(${mkCStr "User name `${cfg.user}' not found."}, stderr);
          else
            perror("getpwnam");
          return EXIT_FAILURE;
        }
        errno = 0;
        if ((groupinfo = getgrnam(${mkCStr cfg.group})) == NULL) {
          if (errno == 0)
            fputs(${mkCStr "Group name `${cfg.group}' not found."}, stderr);
          else
            perror("getgrnam");
          return EXIT_FAILURE;
        }
        if (setgid(groupinfo->gr_gid) == -1) {
          perror("setgid");
          return EXIT_FAILURE;
        }
        if (setuid(userinfo->pw_uid) == -1) {
          perror("setgid");
          return EXIT_FAILURE;
        }
        argv[0] = "taskd";
        if (execv(${mkCStr taskd}, argv) == -1) {
          perror("execv");
          return EXIT_FAILURE;
        }
        /* never reached */
        return EXIT_SUCCESS;
      }
    '';
  in pkgs.runCommand "taskd-user" {} ''
    cc -Wall -std=c11 "${runUser}" -o "$out"
  '';

  subcommands = {
    list-users = {
      args = [ "organisation" ];

      description = [
        "List all users belonging to the specified organisation."
      ];

      script = ''
        legend "The following users exist for $organisation:"
        ${pkgs.findutils}/bin/find \
          "${cfg.dataDir}/orgs/$organisation/users" \
          -mindepth 2 -maxdepth 2 -name config \
          -exec ${pkgs.gnused}/bin/sed -ne 's/^user *= *//p' {} +
      '';
    };

    list-orgs = {
      args = [];

      description = [
        "List available organisations"
      ];

      script = ''
        legend "The following organisations exist:"
        ${pkgs.findutils}/bin/find \
          "${cfg.dataDir}/orgs" -mindepth 1 -maxdepth 1 \
          -type d
      '';
    };

    get-uuid = {
      args = [ "organisation" "user" ];

      description = [
        "Get the UUID of the specified user belonging to the specified"
        "organisation."
      ];

      script = ''
        for uuid in "${cfg.dataDir}/orgs/$organisation/users"/*; do
          usr="$(${pkgs.gnused}/bin/sed -ne 's/^user *= *//p' "$uuid/config")"
          if [ "$usr" = "$user" ]; then
            legend "User $user has the following UUID:"
            echo "$(${pkgs.coreutils}/bin/basename "$uuid")"
            exit 0
          fi
        done
        echo "No UUID found for user $user." >&2
        exit 1
      '';
    };

    export-user = {
      args = [ "organisation" "user" ];

      description = [
        "Export user of the specified organisation as a series of shell"
        "commands that can be used on the client side to easily import"
        "the certificates."
        ""
        "Note that the private key will be exported as well, so use this"
        "with care!"
      ];

      script = ''
        if ! subcmd_quiet list-users "$organisation" | grep -qxF "$user"; then
          exists "User $user doesn't exist in organisation $organisation."
        fi

        uuid="$(subcmd_quiet get-uuid "$organisation" "$user")" || exit 1

        cat <<COMMANDS
        taskdatadir="\''${TASKDATA:-\$HOME/.task}"
        umask 0077
        mkdir -p "\$taskdatadir/keys"
        cat > "\$taskdatadir/keys/public.cert" <<EOF
        $(cat "${cfg.dataDir}/keys/user/$organisation/$user/public.cert")
        EOF
        cat > "\$taskdatadir/keys/private.key" <<EOF
        $(${pkgs.gnused}/bin/sed -ne '/^---* *BEGIN /,/^---* *END /p' \
          "${cfg.dataDir}/keys/user/$organisation/$user/private.key")
        EOF
        cat > "\$taskdatadir/keys/ca.cert" <<EOF
        $(cat "${cfg.dataDir}/keys/ca.cert")
        EOF
        task config taskd.certificate -- "\$taskdatadir/keys/public.cert"
        task config taskd.key         -- "\$taskdatadir/keys/private.key"
        task config taskd.ca          -- "\$taskdatadir/keys/ca.cert"
        task config taskd.credentials -- "$organisation/$user/$uuid"
        COMMANDS
      '';
    };

    add-org = {
      args = [ "name" ];

      description = [
        "Create an organisation with the specified name."
      ];

      script = ''
        if [ -e "orgs/$name" ]; then
          exists "Organisation with name $name already exists."
        fi
        ${taskdUser} add org "$name"
      '';
    };

    add-user = {
      args = [ "organisation" "user" ];

      description = [
        "Create a user for the given organisation and print the UUID along"
        "with the client certificate and key."
      ];

      script = ''
        if subcmd list-users "$organisation" | grep -qxF "$user"; then
          exists "User $user already exists in organisation $organisation."
        fi
        ${taskdUser} add user "$organisation" "$user"
        ${genClientKey}
      '';
    };

    add-group = {
      args = [ "organisation" "group" ];

      description = [
        "Create a group for the given organisation."
      ];

      script = ''
        if [ -e "orgs/$organisation/groups/$group" ]; then
          exists "Group $group already exists in organisation $organisation."
        fi
        ${taskdUser} add group "$organisation" "$group"
      '';
    };
  };

  mkCase = name: { args, ... }: let
    mkPosArg = pos: const "\"\$${toString (pos + 1)}\"";
    cmdArgs = concatImapStringsSep " " mkPosArg args;
  in ''
    ${name})
      if [ $# -ne ${toString ((length args) + 1)} ]; then
        echo "Wrong number of arguments to ${name}." >&2
        echo >&2
        usage_${mkShellName name}
        exit 1
      fi
      subcmd "${name}" ${cmdArgs};;
  '';

  nixos-taskdctl = pkgs.writeScriptBin "nixos-taskdctl" ''
    #!${pkgs.stdenv.shell}
    export TASKDDATA=${mkShellStr cfg.dataDir}

    quiet=0
    # Deliberately undocumented, because we don't want people to use this as
    # it's only used in and specific to the preStart script of the Taskserver
    # service.
    if [ "$1" = "--service-helper" ]; then
      quiet=1
      exists() {
        exit 0
      }
      shift
    else
      exists() {
        echo "$@" >&2
        exit 1
      }
    fi

    legend() {
      if [ $quiet -eq 0 ]; then
        echo "$@" >&2
      fi
    }

    subcmd() {
      local cmdname="''${1//-/_}"
      shift
      "subcmd_$cmdname" "$@"
    }

    subcmd_quiet() {
      local prev_quiet=$quiet
      quiet=1
      subcmd "$@"
      local ret=$?
      quiet=$prev_quiet
      return $ret
    }

    ${concatStrings (mapAttrsToList mkSubCommand subcommands)}

    case "$1" in
      ${concatStrings (mapAttrsToList mkCase subcommands)}
      *) echo "Usage: nixos-taskdctl <subcommand> [<args>]" >&2
         echo >&2
         echo "A tool to manage taskserver users on NixOS" >&2
         echo >&2
         echo "The following subcommands are available:" >&2
         ${concatMapStringsSep "\n     " (c: "usage_${mkShellName c}")
                                         (attrNames subcommands)}
         exit 1
    esac
  '';

  ctlcmd = "${nixos-taskdctl}/bin/nixos-taskdctl --service-helper";

in {

  options = {
    services.taskserver = {

      enable = mkEnableOption "the Taskwarrior server";

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

      caCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Fully qualified path to the CA certificate.";
      };

      ciphers = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "NORMAL";
        description = ''
          List of GnuTLS ciphers to use. See the GnuTLS documentation for full
          details.
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

      client = {

        allow = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "[Tt]ask [2-9]+" ];
          description = ''
            A list of regular expressions that are matched against the reported
            client id (such as <literal>task 2.3.0</literal>).

            The values <literal>all</literal> or <literal>none</literal> have
            special meaning. Overidden by any entry in the option
            <option>services.taskserver.client.deny</option>.
          '';
        };

        cert = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path of the client cert. This is used by the
            <command>client</command> command.
          '';
        };

        deny = mkOption {
          type = types.listOf types.str;
          default = [];
          example = [ "[Tt]ask [2-9]+" ];
          description = ''
            A list of regular expressions that are matched against the reported
            client id (such as <literal>task 2.3.0</literal>).

            The values <literal>all</literal> or <literal>none</literal> have
            special meaning. Any entry here overrides these in
            <option>services.taskserver.client.allow</option>.
          '';
        };

      };

      server = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            The address (IPv4, IPv6 or DNS) to listen on.
          '';
        };

        port = mkOption {
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
            The fully qualified domain name of this server.
          '';
        };

        cert = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Fully qualified path to the server certificate";
        };

        crl = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path to the server certificate revocation list.
          '';
        };

        key = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Fully qualified path to the server key.

            Note that reloading the <literal>taskserver.service</literal> causes
            a configuration file reload before the next request is handled.
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
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.taskserver nixos-taskdctl ];

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

    systemd.services.taskserver-ca = mkIf needToCreateCA {
      requiredBy = [ "taskserver.service" ];
      after = [ "taskserver-init.service" ];
      description = "Initialize CA for TaskServer";
      serviceConfig.Type = "oneshot";
      serviceConfig.UMask = "0077";

      script = ''
        mkdir -m 0700 -p "${cfg.dataDir}/keys"
        chown root:root "${cfg.dataDir}/keys"

        if [ ! -e "${cfg.dataDir}/keys/ca.key" ]; then
          ${pkgs.gnutls}/bin/certtool -p \
            --bits 2048 \
            --outfile "${cfg.dataDir}/keys/ca.key"
          ${pkgs.gnutls}/bin/certtool -s \
            --template "${pkgs.writeText "taskserver-ca.template" ''
              cn = ${cfg.server.fqdn}
              cert_signing_key
              ca
            ''}" \
            --load-privkey "${cfg.dataDir}/keys/ca.key" \
            --outfile "${cfg.dataDir}/keys/ca.cert"

          chgrp "${cfg.group}" "${cfg.dataDir}/keys/ca.cert"
          chmod g+r "${cfg.dataDir}/keys/ca.cert"
        fi

        if [ ! -e "${cfg.dataDir}/keys/server.key" ]; then
          ${pkgs.gnutls}/bin/certtool -p \
            --bits 2048 \
            --outfile "${cfg.dataDir}/keys/server.key"

          ${pkgs.gnutls}/bin/certtool -c \
            --template "${pkgs.writeText "taskserver-cert.template" ''
              cn = ${cfg.server.fqdn}
              tls_www_server
              encryption_key
              signing_key
            ''}" \
            --load-ca-privkey "${cfg.dataDir}/keys/ca.key" \
            --load-ca-certificate "${cfg.dataDir}/keys/ca.cert" \
            --load-privkey "${cfg.dataDir}/keys/server.key" \
            --outfile "${cfg.dataDir}/keys/server.cert"

          chgrp "${cfg.group}" "${cfg.dataDir}/keys/server.key"
          chmod g+r "${cfg.dataDir}/keys/server.key"
          chmod a+r "${cfg.dataDir}/keys/server.cert"
        fi

        chmod go+x "${cfg.dataDir}/keys"
      '';
    };

    systemd.services.taskserver-init = {
      requiredBy = [ "taskserver.service" ];
      description = "Initialize Taskserver Data Directory";

      preStart = ''
        mkdir -m 0770 -p "${cfg.dataDir}"
        chown "${cfg.user}:${cfg.group}" "${cfg.dataDir}"
      '';

      script = ''
        ${taskd} init
        echo "include ${configFile}" > "${cfg.dataDir}/config"
        touch "${cfg.dataDir}/.is_initialized"
      '';

      environment.TASKDDATA = cfg.dataDir;

      unitConfig.ConditionPathExists = "!${cfg.dataDir}/.is_initialized";

      serviceConfig.Type = "oneshot";
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
      serviceConfig.PermissionsStartOnly = true;
    };

    systemd.services.taskserver = {
      description = "Taskwarrior Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment.TASKDDATA = cfg.dataDir;

      preStart = ''
        ${concatStrings (mapAttrsToList (orgName: attrs: ''
          ${ctlcmd} add-org ${mkShellStr orgName}

          ${concatMapStrings (user: ''
            echo Creating ${user} >&2
            ${ctlcmd} add-user ${mkShellStr orgName} ${mkShellStr user}
          '') attrs.users}

          ${concatMapStrings (group: ''
            ${ctlcmd} add-group ${mkShellStr orgName} ${mkShellStr user}
          '') attrs.groups}
        '') cfg.organisations)}
      '';

      serviceConfig = {
        ExecStart = "@${taskd} taskd server";
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
