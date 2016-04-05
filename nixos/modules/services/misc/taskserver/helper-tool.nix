{ config, pkgs, lib, mkShellStr, taskd }:

let
  mkShellName = lib.replaceStrings ["-"] ["_"];

  genClientKey = ''
    umask 0077
    if tmpdir="$(${pkgs.coreutils}/bin/mktemp -d)"; then
      trap "rm -rf '$tmpdir'" EXIT
      ${pkgs.gnutls}/bin/certtool -p --bits 2048 --outfile "$tmpdir/key"

      cat > "$tmpdir/template" <<-\ \ EOF
      organization = $organisation
      cn = ${config.server.fqdn}
      tls_www_client
      encryption_key
      signing_key
      EOF

      ${pkgs.gnutls}/bin/certtool -c \
        --load-privkey "$tmpdir/key" \
        --load-ca-privkey "${config.dataDir}/keys/ca.key" \
        --load-ca-certificate "${config.dataDir}/keys/ca.cert" \
        --template "$tmpdir/template" \
        --outfile "$tmpdir/cert"

      mkdir -m 0700 -p "${config.dataDir}/keys/user/$organisation/$user"
      chown root:root "${config.dataDir}/keys/user/$organisation/$user"
      cat "$tmpdir/key" \
        > "${config.dataDir}/keys/user/$organisation/$user/private.key"
      cat "$tmpdir/cert" \
        > "${config.dataDir}/keys/user/$organisation/$user/public.cert"

      rm -rf "$tmpdir"
      trap - EXIT
    else
      echo "Unable to create temporary directory for client" \
           "certificate creation." >&2
      exit 1
    fi
  '';

  mkSubCommand = name: { args, description, script }: let
    mkArg = pos: arg: "local ${arg}=\"\$${toString pos}\"";
    mkDesc = line: "echo ${mkShellStr "    ${line}"} >&2";
    usagePosArgs = lib.concatMapStringsSep " " (a: "<${a}>") args;
  in ''
    subcmd_${mkShellName name}() {
      ${lib.concatImapStringsSep "\n  " mkArg args}
      ${script}
    }

    usage_${mkShellName name}() {
      echo "  nixos-taskdctl ${name} ${usagePosArgs}" >&2
      ${lib.concatMapStringsSep "\n  " mkDesc description}
    }
  '';

  mkCStr = val: "\"${lib.escape ["\\" "\""] val}\"";

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
        if ((userinfo = getpwnam(${mkCStr config.user})) == NULL) {
          if (errno == 0)
            fputs(${mkCStr "User name `${config.user}' not found."}, stderr);
          else
            perror("getpwnam");
          return EXIT_FAILURE;
        }
        errno = 0;
        if ((groupinfo = getgrnam(${mkCStr config.group})) == NULL) {
          if (errno == 0)
            fputs(${mkCStr "Group name `${config.group}' not found."}, stderr);
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
          "${config.dataDir}/orgs/$organisation/users" \
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
          "${config.dataDir}/orgs" -mindepth 1 -maxdepth 1 \
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
        for uuid in "${config.dataDir}/orgs/$organisation/users"/*; do
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
        $(cat "${config.dataDir}/keys/user/$organisation/$user/public.cert")
        EOF
        cat > "\$taskdatadir/keys/private.key" <<EOF
        $(${pkgs.gnused}/bin/sed -ne '/^---* *BEGIN /,/^---* *END /p' \
          "${config.dataDir}/keys/user/$organisation/$user/private.key")
        EOF
        cat > "\$taskdatadir/keys/ca.cert" <<EOF
        $(cat "${config.dataDir}/keys/ca.cert")
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
    mkPosArg = pos: lib.const "\"\$${toString (pos + 1)}\"";
    cmdArgs = lib.concatImapStringsSep " " mkPosArg args;
  in ''
    ${name})
      if [ $# -ne ${toString ((lib.length args) + 1)} ]; then
        echo "Wrong number of arguments to ${name}." >&2
        echo >&2
        usage_${mkShellName name}
        exit 1
      fi
      subcmd "${name}" ${cmdArgs};;
  '';

in pkgs.writeScriptBin "nixos-taskdctl" ''
  #!${pkgs.stdenv.shell}
  export TASKDDATA=${mkShellStr config.dataDir}

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

  ${lib.concatStrings (lib.mapAttrsToList mkSubCommand subcommands)}

  case "$1" in
    ${lib.concatStrings (lib.mapAttrsToList mkCase subcommands)}
    *) echo "Usage: nixos-taskdctl <subcommand> [<args>]" >&2
       echo >&2
       echo "A tool to manage taskserver users on NixOS" >&2
       echo >&2
       echo "The following subcommands are available:" >&2
       ${lib.concatMapStringsSep "\n     " (c: "usage_${mkShellName c}")
                                           (lib.attrNames subcommands)}
       exit 1
  esac
''
