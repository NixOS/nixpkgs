{ config, lib, pkgs, ... }:

with lib;

let

  ids = config.ids;
  cfg = config.users;

  nonUidUsers = filterAttrs (n: u: u.createUser && u.uid == null) cfg.extraUsers;
  nonGidGroups = filterAttrs (n: g: g.gid == null) cfg.extraGroups;

  passwordDescription = ''
    The options <literal>hashedPassword</literal>,
    <literal>password</literal> and <literal>passwordFile</literal>
    controls what password is set for the user.
    <literal>hashedPassword</literal> overrides both
    <literal>password</literal> and <literal>passwordFile</literal>.
    <literal>password</literal> overrides <literal>passwordFile</literal>.
    If none of these three options are set, no password is assigned to
    the user, and the user will not be able to do password logins.
    If the option <literal>users.mutableUsers</literal> is true, the
    password defined in one of the three options will only be set when
    the user is created for the first time. After that, you are free to
    change the password with the ordinary user management commands. If
    <literal>users.mutableUsers</literal> is false, you cannot change
    user passwords, they will always be set according to the password
    options.
  '';

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };

      description = mkOption {
        type = types.str;
        default = "";
        example = "Alice Q. User";
        description = ''
          A short description of the user account, typically the
          user's full name.  This is actually the “GECOS” or “comment”
          field in <filename>/etc/passwd</filename>.
        '';
      };

      uid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          The account UID. If the <option>mutableUsers</option> option
          is false, the UID cannot be null. Otherwise, the UID might be
          null, in which case a free UID is picked on activation (by the
          useradd command).
        '';
      };

      isSystemUser = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Indicates if the user is a system user or not. This option
          only has an effect if <option>mutableUsers</option> is
          <literal>true</literal> and <option>uid</option> is
          <option>null</option>, in which case it determines whether
          the user's UID is allocated in the range for system users
          (below 500) or in the range for normal users (starting at
          1000).
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "The user's primary group.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The user's auxiliary groups.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/empty";
        description = "The user's home directory.";
      };

      shell = mkOption {
        type = types.str;
        default = "/run/current-system/sw/sbin/nologin";
        description = "The path to the user's shell.";
      };

      createHome = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the home directory will be created automatically. If this
          option is true and the home directory already exists but is not
          owned by the user, directory owner and group will be changed to
          match the user.
        '';
      };

      useDefaultShell = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the user's shell will be set to
          <literal>cfg.defaultUserShell</literal>.
        '';
      };

      hashedPassword = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the (hashed) password for the user.
          ${passwordDescription}
        '';
      };

      password = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the (clear text) password for the user.
          Warning: do not set confidential information here
          because it is world-readable in the Nix store. This option
          should only be used for public accounts.
          ${passwordDescription}
        '';
      };

      passwordFile = mkOption {
        type = with types; uniq (nullOr string);
        default = null;
        description = ''
          The path to a file that contains the user's password. The password
          file is read on each system activation. The file should contain
          exactly one line, which should be the password in an encrypted form
          that is suitable for the <literal>chpasswd -e</literal> command.
          ${passwordDescription}
        '';
      };

      createUser = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Indicates if the user should be created automatically as a local user.
          Set this to false if the user for instance is an LDAP user. NixOS will
          then not modify any of the basic properties for the user account.
        '';
      };
    };

    config = {
      name = mkDefault name;
      shell = mkIf config.useDefaultShell (mkDefault cfg.defaultUserShell);
    };

  };

  groupOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = ''
          The name of the group. If undefined, the name of the attribute set
          will be used.
        '';
      };

      gid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          The group GID. If the <literal>mutableUsers</literal> option
          is false, the GID cannot be null. Otherwise, the GID might be
          null, in which case a free GID is picked on activation (by the
          groupadd command).
        '';
      };

      members = mkOption {
        type = with types; listOf string;
        default = [];
        description = ''
          The user names of the group members, added to the
          <literal>/etc/group</literal> file.
        '';
      };

    };

    config = {
      name = mkDefault name;
    };

  };

  getGroup = gname:
    let
      groups = mapAttrsToList (n: g: g) (
        filterAttrs (n: g: g.name == gname) cfg.extraGroups
      );
    in
      if length groups == 1 then head groups
      else if groups == [] then throw "Group ${gname} not defined"
      else throw "Group ${gname} has multiple definitions";

  getUser = uname:
    let
      users = mapAttrsToList (n: u: u) (
        filterAttrs (n: u: u.name == uname) cfg.extraUsers
      );
    in
      if length users == 1 then head users
      else if users == [] then throw "User ${uname} not defined"
      else throw "User ${uname} has multiple definitions";

  mkGroupEntry = gname:
    let
      g = getGroup gname;
      users = mapAttrsToList (n: u: u.name) (
        filterAttrs (n: u: elem g.name u.extraGroups) cfg.extraUsers
      );
    in concatStringsSep ":" [
      g.name "x" (toString g.gid)
      (concatStringsSep "," (users ++ (filter (u: !(elem u users)) g.members)))
    ];

  mkPasswdEntry = uname: let u = getUser uname; in
    concatStringsSep ":" [
      u.name "x" (toString u.uid)
      (toString (getGroup u.group).gid)
      u.description u.home u.shell
    ];

  sortOn = a: sort (as1: as2: lessThan (getAttr a as1) (getAttr a as2));

  groupFile = pkgs.writeText "group" (
    concatStringsSep "\n" (map (g: mkGroupEntry g.name) (
      let f = g: g.gid != null; in
        sortOn "gid" (filter f (attrValues cfg.extraGroups))
    ))
  );

  passwdFile = pkgs.writeText "passwd" (
    concatStringsSep "\n" (map (u: mkPasswdEntry u.name) (
      let f = u: u.createUser && (u.uid != null); in
        sortOn "uid" (filter f (attrValues cfg.extraUsers))
    ))
  );

  # If mutableUsers is true, this script adds all users/groups defined in
  # users.extra{Users,Groups} to /etc/{passwd,group} iff there isn't any
  # existing user/group with the same name in those files.
  # If mutableUsers is false, the /etc/{passwd,group} files will simply be
  # replaced with the users/groups defined in the NixOS configuration.
  # The merging procedure could certainly be improved, and instead of just
  # keeping the lines as-is from /etc/{passwd,group} they could be combined
  # in some way with the generated content from the NixOS configuration.
  merger = src: pkgs.writeScript "merger" ''
    #!${pkgs.bash}/bin/bash

    PATH=${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:$PATH

    ${if !cfg.mutableUsers
      then ''cp ${src} $1.tmp''
      else ''awk -F: '{ print "^"$1":.*" }' $1 | egrep -vf - ${src} | cat $1 - > $1.tmp''
    }

    # set mtime to +1, otherwise change might go unnoticed (vipw/vigr only looks at mtime)
    touch -m -t $(date -d @$(($(stat -c %Y $1)+1)) +%Y%m%d%H%M.%S) $1.tmp

    mv -f $1.tmp $1
  '';

  idsAreUnique = set: idAttr: !(fold (name: args@{ dup, acc }:
    let
      id = builtins.toString (builtins.getAttr idAttr (builtins.getAttr name set));
      exists = builtins.hasAttr id acc;
      newAcc = acc // (builtins.listToAttrs [ { name = id; value = true; } ]);
    in if dup then args else if exists
      then builtins.trace "Duplicate ${idAttr} ${id}" { dup = true; acc = null; }
      else { dup = false; acc = newAcc; }
    ) { dup = false; acc = {}; } (builtins.attrNames set)).dup;

  uidsAreUnique = idsAreUnique (filterAttrs (n: u: u.uid != null) cfg.extraUsers) "uid";
  gidsAreUnique = idsAreUnique (filterAttrs (n: g: g.gid != null) cfg.extraGroups) "gid";

in {

  ###### interface

  options = {

    users.mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If true, you are free to add new users and groups to the system
        with the ordinary <literal>useradd</literal> and
        <literal>groupadd</literal> commands. On system activation, the
        existing contents of the <literal>/etc/passwd</literal> and
        <literal>/etc/group</literal> files will be merged with the
        contents generated from the <literal>users.extraUsers</literal> and
        <literal>users.extraGroups</literal> options. If
        <literal>mutableUsers</literal> is false, the contents of the user and
        group files will simply be replaced on system activation. This also
        holds for the user passwords; if this option is false, all changed
        passwords will be reset according to the
        <literal>users.extraUsers</literal> configuration on activation. If
        this option is true, the initial password for a user will be set
        according to <literal>users.extraUsers</literal>, but existing passwords
        will not be changed.
      '';
    };

    users.enforceIdUniqueness = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to require that no two users/groups share the same uid/gid.
      '';
    };

    users.extraUsers = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        alice = {
          uid = 1234;
          description = "Alice Q. User";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = ["wheel"];
          shell = "/bin/sh";
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

    security.initialRootPassword = mkOption {
      type = types.str;
      default = "!";
      example = "";
      description = ''
        The (hashed) password for the root account set on initial
        installation. The empty string denotes that root can login
        locally without a password (but not via remote services such
        as SSH, or indirectly via <command>su</command> or
        <command>sudo</command>). The string <literal>!</literal>
        prevents root from logging in using a password.
        Note that setting this option sets
        <literal>users.extraUsers.root.hashedPassword</literal>.
        Also, if <literal>users.mutableUsers</literal> is false
        you cannot change the root password manually, so in that case
        the name of this option is a bit misleading, since it will define
        the root password beyond the user initialisation phase.
      '';
    };

  };


  ###### implementation

  config = {

    users.extraUsers = {
      root = {
        uid = ids.uids.root;
        description = "System administrator";
        home = "/root";
        shell = mkDefault cfg.defaultUserShell;
        group = "root";
        extraGroups = [ "grsecurity" ];
        hashedPassword = mkDefault config.security.initialRootPassword;
      };
      nobody = {
        uid = ids.uids.nobody;
        description = "Unprivileged account (don't use!)";
        group = "nogroup";
      };
    };

    users.extraGroups = {
      root.gid = ids.gids.root;
      wheel.gid = ids.gids.wheel;
      disk.gid = ids.gids.disk;
      kmem.gid = ids.gids.kmem;
      tty.gid = ids.gids.tty;
      floppy.gid = ids.gids.floppy;
      uucp.gid = ids.gids.uucp;
      lp.gid = ids.gids.lp;
      cdrom.gid = ids.gids.cdrom;
      tape.gid = ids.gids.tape;
      audio.gid = ids.gids.audio;
      video.gid = ids.gids.video;
      dialout.gid = ids.gids.dialout;
      nogroup.gid = ids.gids.nogroup;
      users.gid = ids.gids.users;
      nixbld.gid = ids.gids.nixbld;
      utmp.gid = ids.gids.utmp;
      adm.gid = ids.gids.adm;
      grsecurity.gid = ids.gids.grsecurity;
    };

    system.activationScripts.users =
      let
        mkhomeUsers = filterAttrs (n: u: u.createHome) cfg.extraUsers;
        setpwUsers = filterAttrs (n: u: u.createUser) cfg.extraUsers;
        pwFile = u: if !(isNull u.hashedPassword)
          then pkgs.writeTextFile { name = "password-file"; text = u.hashedPassword; }
          else if !(isNull u.password)
          then pkgs.runCommand "password-file" { pw = u.password; } ''
            echo -n "$pw" | ${pkgs.mkpasswd}/bin/mkpasswd -s > $out
          '' else u.passwordFile;
        setpw = n: u: ''
          setpw=yes
          ${optionalString cfg.mutableUsers ''
            test "$(getent shadow '${u.name}' | cut -d: -f2)" != "x" && setpw=no
          ''}
          if [ "$setpw" == "yes" ]; then
            ${if !(isNull (pwFile u))
              then ''
                echo -n "${u.name}:" | cat - "${pwFile u}" | \
                  ${pkgs.shadow}/sbin/chpasswd -e
              ''
              else "passwd -l '${u.name}' &>/dev/null"
            }
          fi
        '';
        mkhome = n: u: ''
          uid="$(id -u ${u.name})"
          gid="$(id -g ${u.name})"
          h="${u.home}"
          test -a "$h" || mkdir -p "$h" || true
          test "$(stat -c %u "$h")" = $uid || chown $uid "$h" || true
          test "$(stat -c %g "$h")" = $gid || chgrp $gid "$h" || true
        '';
        groupadd = n: g: ''
          if [ -z "$(getent group "${g.name}")" ]; then
            ${pkgs.shadow}/sbin/groupadd "${g.name}"
          fi
        '';
        useradd = n: u: ''
          if ! id "${u.name}" &>/dev/null; then
            ${pkgs.shadow}/sbin/useradd \
              -g "${u.group}" \
              -G "${concatStringsSep "," u.extraGroups}" \
              -s "${u.shell}" \
              -d "${u.home}" \
              ${optionalString u.isSystemUser "--system"} \
              "${u.name}"
            echo "${u.name}:x" | ${pkgs.shadow}/sbin/chpasswd -e
          fi
        '';
      in stringAfter [ "etc" ] ''
        touch /etc/group
        touch /etc/passwd
        VISUAL=${merger groupFile} ${pkgs.shadow}/sbin/vigr &>/dev/null
        VISUAL=${merger passwdFile} ${pkgs.shadow}/sbin/vipw &>/dev/null
        ${pkgs.shadow}/sbin/grpconv
        ${pkgs.shadow}/sbin/pwconv
        ${concatStrings (mapAttrsToList groupadd nonGidGroups)}
        ${concatStrings (mapAttrsToList useradd nonUidUsers)}
        ${concatStrings (mapAttrsToList mkhome mkhomeUsers)}
        ${concatStrings (mapAttrsToList setpw setpwUsers)}
      '';

    # for backwards compatibility
    system.activationScripts.groups = stringAfter [ "users" ] "";

    assertions = [
      { assertion = !cfg.enforceIdUniqueness || (uidsAreUnique && gidsAreUnique);
        message = "uids and gids must be unique!";
      }
      { assertion = cfg.mutableUsers || (nonUidUsers == {});
        message = "When mutableUsers is false, no uid can be null: ${toString (attrNames nonUidUsers)}";
      }
      { assertion = cfg.mutableUsers || (nonGidGroups == {});
        message = "When mutableUsers is false, no gid can be null";
      }
    ];

  };

}
