{pkgs, config, ...}:

with pkgs.lib;

let

  ids = config.ids;
  users = config.users;

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = with types; uniq string;
        description = "The name of the user account. If undefined, the name of the attribute set will be used.";
      };

      description = mkOption {
        type = with types; uniq string;
        default = "";
        description = "A short description of the user account.";
      };

      uid = mkOption {
        type = with types; uniq (nullOr int);
        default = null;
        description = "The account UID. If undefined, NixOS will select a free UID.";
      };

      group = mkOption {
        type = with types; uniq string;
        default = "nogroup";
        description = "The user's primary group.";
      };

      extraGroups = mkOption {
        type = types.listOf types.string;
        default = [];
        description = "The user's auxiliary groups.";
      };

      home = mkOption {
        type = with types; uniq string;
        default = "/var/empty";
        description = "The user's home directory.";
      };

      shell = mkOption {
        type = with types; uniq string;
        default = "/run/current-system/sw/sbin/nologin";
        description = "The path to the user's shell.";
      };

      createHome = mkOption {
        type = types.bool;
        default = false;
        description = "If true, the home directory will be created automatically.";
      };

      useDefaultShell = mkOption {
        type = types.bool;
        default = false;
        description = "If true, the user's shell will be set to <literal>users.defaultUserShell</literal>.";
      };

      password = mkOption {
        type = with types; uniq (nullOr string);
        default = null;
        description = "The user's password. If undefined, no password is set for the user.  Warning: do not set confidential information here because this data would be readable by all.  This option should only be used for public account such as guest.";
      };

      isSystemUser = mkOption {
        type = types.bool;
        default = true;
        description = "Indicates if the user is a system user or not.";
      };

      createUser = mkOption {
        type = types.bool;
        default = true;
        description = "
          Indicates if the user should be created automatically as a local user.
          Set this to false if the user for instance is an LDAP user. NixOS will
          then not modify any of the basic properties for the user account.
        ";
      };

      isAlias = mkOption {
        type = types.bool;
        default = false;
        description = "If true, the UID of this user is not required to be unique and can thus alias another user.";
      };

    };

    config = {
      name = mkDefault name;
      uid = mkDefault (attrByPath [name] null ids.uids);
      shell = mkIf config.useDefaultShell (mkDefault users.defaultUserShell);
    };

  };

  groupOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = with types; uniq string;
        description = "The name of the group. If undefined, the name of the attribute set will be used.";
      };

      gid = mkOption {
        type = with types; uniq (nullOr int);
        default = null;
        description = "The GID of the group. If undefined, NixOS will select a free GID.";
      };

    };

    config = {
      name = mkDefault name;
      gid = mkDefault (attrByPath [name] null ids.gids);
    };

  };

  # Note: the 'X' in front of the password is to distinguish between
  # having an empty password, and not having a password.
  serializedUser = u: "${u.name}\n${u.description}\n${if u.uid != null then toString u.uid else ""}\n${u.group}\n${toString (concatStringsSep "," u.extraGroups)}\n${u.home}\n${u.shell}\n${toString u.createHome}\n${if u.password != null then "X" + u.password else ""}\n${toString u.isSystemUser}\n${toString u.createUser}\n${toString u.isAlias}\n";

  usersFile = pkgs.writeText "users" (
    let
      p = partition (u: u.isAlias) (attrValues config.users.extraUsers);
    in concatStrings (map serializedUser p.wrong ++ map serializedUser p.right));

in

{

  ###### interface

  options = {

    users.extraUsers = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        alice = {
          uid = 1234;
          description = "Alice";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = ["wheel"];
          shell = "/bin/sh";
          password = "foobar";
        };
      };
      description = ''
        Additional user accounts to be created automatically by the system.
        This can also be used to set options for root.
      '';
      options = [ userOpts ];
    };

    users.extraGroups = mkOption {
      default = {};
      example =
        { students.gid = 1001;
          hackers = { };
        };
      type = types.loaOf types.optionSet;
      description = ''
        Additional groups to be created automatically by the system.
      '';
      options = [ groupOpts ];
    };

  };


  ###### implementation

  config = {

    users.extraUsers = {
      root = {
        description = "System administrator";
        home = "/root";
        shell = config.users.defaultUserShell;
        group = "root";
      };
      nobody = {
        description = "Unprivileged account (don't use!)";
      };
    };

    users.extraGroups = {
      root = { };
      wheel = { };
      disk = { };
      kmem = { };
      tty = { };
      floppy = { };
      uucp = { };
      lp = { };
      cdrom = { };
      tape = { };
      audio = { };
      video = { };
      dialout = { };
      nogroup = { };
      users = { };
      nixbld = { };
      utmp = { };
      adm = { }; # expected by journald
    };

    system.activationScripts.rootPasswd = stringAfter [ "etc" ]
      ''
        # If there is no password file yet, create a root account with an
        # empty password.
        if ! test -e /etc/passwd; then
            rootHome=/root
            touch /etc/passwd; chmod 0644 /etc/passwd
            touch /etc/group; chmod 0644 /etc/group
            touch /etc/shadow; chmod 0600 /etc/shadow
            # Can't use useradd, since it complains that it doesn't know us
            # (bootstrap problem!).
            echo "root:x:0:0:System administrator:$rootHome:${config.users.defaultUserShell}" >> /etc/passwd
            echo "root::::::::" >> /etc/shadow
        fi
      '';

    system.activationScripts.users = stringAfter [ "groups" ]
      ''
        echo "updating users..."

        cat ${usersFile} | while true; do
            read name || break
            read description
            read uid
            read group
            read extraGroups
            read home
            read shell
            read createHome
            read password
            read isSystemUser
            read createUser
            read isAlias

            if [ -z "$createUser" ]; then
                continue
            fi

            if ! curEnt=$(getent passwd "$name"); then
                useradd ''${isSystemUser:+--system} \
                    --comment "$description" \
                    ''${uid:+--uid $uid} \
                    --gid "$group" \
                    --groups "$extraGroups" \
                    --home "$home" \
                    --shell "$shell" \
                    ''${createHome:+--create-home} \
                    ''${isAlias:+--non-unique} \
                    "$name"
                if test "''${password:0:1}" = 'X'; then
                    (echo "''${password:1}"; echo "''${password:1}") | ${pkgs.shadow}/bin/passwd "$name"
                fi
            else
                #echo "updating user $name..."
                oldIFS="$IFS"; IFS=:; set -- $curEnt; IFS="$oldIFS"
                prevUid=$3
                prevHome=$6
                # Don't change the home directory if it's the same to prevent
                # unnecessary warnings about logged in users.
                if test "$prevHome" = "$home"; then unset home; fi
                usermod \
                    --comment "$description" \
                    --gid "$group" \
                    --groups "$extraGroups" \
                    ''${home:+--home "$home"} \
                    --shell "$shell" \
                    "$name"
            fi

        done
      '';

    system.activationScripts.groups = stringAfter [ "rootPasswd" "binsh" "etc" "var" ]
      ''
        echo "updating groups..."

        createGroup() {
            name="$1"
            gid="$2"

            if ! curEnt=$(getent group "$name"); then
                groupadd --system \
                    ''${gid:+--gid $gid} \
                    "$name"
            fi
        }

        ${flip concatMapStrings (attrValues config.users.extraGroups) (g: ''
          createGroup '${g.name}' '${toString g.gid}'
        '')}
      '';

  };

}
